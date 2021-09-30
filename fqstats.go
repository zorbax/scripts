package main

import (
	"fmt"
	"log"
	"os"
	"bufio"
	"strings"
  "reflect"
	"compress/gzip"
	"github.com/montanaflynn/stats"
	"io"
)

func checkError(err error) {
	if err != nil {
		log.Fatal(err)
	}
}

var totalNum float64
var gcNum float64
var readLengthSlice []float64
var qualMeanS []float64
var qualMap = make(map[int][]float64)
var qualPostStatM = make(map[int]float64)

var q30 float64
var q25 float64

func Round(v float64, decimals int) float64 {
	var pow float64 = 1
	for i := 0; i < decimals; i++ {
		pow *= 10
	}
	return float64(int((v * pow) + 0.5)) / pow
}

func getQualPosMean(m map[int][]float64) (map[int]float64, []float64) {
	var resM = make(map[int]float64)
	var resS []float64

	for k, v := range m {
		mean, _ := stats.Mean(v)
		resM[k] = Round(mean, 0)
		resS = append(resS, mean)
	}
	return resM, resS
}

// calculate q30 q25
func convertQual(qual []rune, m map[int][]float64) map[int][]float64 {

	for i, j := range qual {
		q := float64(j - 33)
		m[i + 1 ] = append(m[i + 1], q)

		if q >= 30 {
			q30++
		}
		if q >= 25 {
			q25++
		}
	}
	return m
}

var readStatMap = make(map[string]float64)

func getStat(s []float64) map[string]float64 {
	var m = make(map[string]float64)
	max, _ := stats.Max(s)
	min, _ := stats.Min(s)
	median, _ := stats.Median(s)
	quarile, _ := stats.Quartile(s)
	mean, _ := stats.Mean(s)

	m["Max"] = max
	m["Min"] = min
	m["Median"] = Round(median, 2)
	m["Mean"] = Round(mean, 2)
	m["q1"] = Round(quarile.Q1, 2)
	m["q2"] = Round(quarile.Q2, 2)
	m["q3"] = Round(quarile.Q3, 2)

	return m
}

func QualCliHelper(q float64) string {
	var tmp = ""

	for i := 1; i <= int(q); i++ {
		if i%5 != 0 {
			tmp += "-"
		} else {
			tmp += "|"
		}
	}
	return tmp

}

func mainHelper(arg []string) {
	if len(arg) != 3 {
		fmt.Println("Usage")
		fmt.Println("-fq : a fastq file")
		fmt.Println("-gz : a fastq.gz file")
		os.Exit(0)
	}

	if arg[1] == "-fq" {
		fastq := arg[2]
		fq, err := os.Open(fastq)
		checkError(err)
		var fqReader = bufio.NewReader(fq)

		Run(fqReader)

		defer fq.Close()
	} else if arg[1] == "-gz" {
		fqgz := arg[2]
		fq, err := os.Open(fqgz)
		checkError(err)
		fqReader, err := gzip.NewReader(fq)
		checkError(err)

		Run(fqReader)

		defer fqReader.Close()
	} else {
		fmt.Println("-fq|-gz option required.")
		os.Exit(0)
	}
}

func Run(fqgz io.Reader) {

	scanner := bufio.NewScanner(fqgz)
	scanner.Split(bufio.ScanLines)
	for scanner.Scan() {
		var line string = strings.TrimSpace(scanner.Text())
		if strings.HasPrefix(line, "@") {
			continue
		} else {
			// sequence line
			gcNum += float64(strings.Count(strings.ToUpper(line), "G"))
			gcNum += float64(strings.Count(strings.ToUpper(line), "C"))
			readLengthSlice = append(readLengthSlice, float64(len(line)))
			// strand
			scanner.Scan()
			// quality
			scanner.Scan()

			var qual []rune = []rune(strings.TrimSpace(scanner.Text()))

			convertQual(qual, qualMap)
		}
	}

	qualPostStatM, qualMeanS = getQualPosMean(qualMap)
	totalNum, _ = stats.Sum(readLengthSlice)
	var gcRatio float64 = Round(gcNum/totalNum*100, 2)
	readStatMap = getStat(readLengthSlice)
    var TotalNum int = int(totalNum)
    var fastq_file string = os.Args[2]

    fmt.Println("file", fastq_file)
	fmt.Println("total_bp", TotalNum)
	// fmt.Println(reflect.TypeOf(totalNum).String())
	fmt.Println("gc_per", gcRatio)
	fmt.Println("total_reads",len(readLengthSlice))
	fmt.Println("max_len",readStatMap["Max"])
	fmt.Println("min_len",readStatMap["Min"])
	fmt.Println("median_len",readStatMap["Median"])
	fmt.Println("mean_len",readStatMap["Mean"])
	fmt.Println("N25_len",readStatMap["q1"])
	fmt.Println("N50_len",readStatMap["q2"])
	fmt.Println("N75_len",readStatMap["q3"])
	qualTotalStatM := getStat(qualMeanS)
	fmt.Println("mean_Q",qualTotalStatM["Mean"])
	fmt.Println("median_Q",qualTotalStatM["Median"])
	fmt.Println("N25_Q",qualTotalStatM["q1"])
	fmt.Println("N50_Q",qualTotalStatM["q2"])
	fmt.Println("N75_Q",qualTotalStatM["q3"])
	fmt.Println("Q30_per_Q",Round(q30/totalNum*100, 2))
	fmt.Println("Q20_per_Q",Round(q25/totalNum*100, 2))
}

func main() {
    mainHelper(os.Args)
}
