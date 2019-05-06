#include "readfastaq.h"
#include <locale>


int main(int argc, char *argv[])
{

  if (argc == 1) {
   fprintf(stderr, "Calculate fasta/fastq stats\n", argv[0]);
   fprintf(stderr, "Usage: %s <file.fq/fa>\n", argv[0]);
   return 1;
  }
  if((fp = gzopen(argv[1],"r")) == NULL){ 
    printf("ERROR main:: missing input file  !! \n");
    return 1;
  }

  int err=1;

  // File type	
  //int isfq=fasttype(argv[1]);

  //if(!isfq)
  err=readfastaq(argv[1],1); // save info (contig names and length) in vectors
  //else
    // err=readfastq(argv[1],1);

  if(!err){
    std::stringstream ss;
//    ss.imbue(std::locale(""));
    int n, n50;
    long int max, bases, l50;
    float mean;

    std::tie(bases,n,mean, max, l50, n50)= calcstats(rlen);  
    ss << std::fixed << std::setprecision(0) <<  "Bases = " << bases << std::endl << "Seqs = "
        << n << std::endl << "Mean_length = " << mean << std::endl << "Longest = " 
        << max << std::endl << "N50 = " << l50 << std::endl <<"N_n50 = " << n50;  
    cout << ss.str();
  }
  return 0;
}

