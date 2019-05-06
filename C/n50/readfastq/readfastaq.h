#include <iomanip>  //setprecision
#include <algorithm>    // sort, reverse
#include <gzstream.h>
#include <vector>  //setprecision
#include <sstream>
#include <numeric> // accumulate
#include <tuple>


using std::cout;
using std::endl;
using std::vector;
using std::string;

static gzFile fp;  // input file
static std::ofstream outfile;  // output_file

static  vector<int> rlen;
static  vector<string> rseq;
static  vector<string> rqual;
static  vector<string> rname;
static  vector<string> rcomment;

static  vector<int> excluded;
static  vector<int> ctgrlen;
static  vector<string> avoid;

// ---------------------------------------- //
int fasttype(char* file)
// ---------------------------------------- //
{ 
  char fq[5]={"@"};
  char fa[5]={">"};
  string ttname;
  int isfq=0;
  igzstream infile(file);

  getline(infile,ttname);
  string ftype=ttname.substr(0,1);
  if(ftype==fa) isfq=0;
  else isfq=1;

  return(isfq);
}


// ---------------------------------------- //
int fill_vectors(string name, int length, string seq="", string comment="", string qual="")
// ---------------------------------------- //
{ 
  rname.push_back(name);
  rlen.push_back(length);
  if ( ! seq.empty())
    rseq.push_back(seq);
  if ( ! comment.empty())
    rcomment.push_back(comment);

  // only for fastq
  if ( ! qual.empty())
    rqual.push_back(qual);


  return 0;
}


// ---------------------------------------- //
int check_cuts(int seqlen,  string ctg="",  int minlen=0,  int maxlen=0, string selctg="", string keep="", string rm="")
// ---------------------------------------- //
{ 
  if( ( seqlen >= minlen ) 
      && ( selctg.size()==0 || selctg.compare(ctg)==0 ) 
      && ( avoid.size() == 0 || std::find(avoid.begin(), avoid.end(), ctg) == avoid.end() )
      && ( maxlen==0 || seqlen < maxlen ) 
      && ( keep.size()==0  ||  ctg.find(keep)!=std::string::npos) 
      && ( rm.size()==0  ||  ctg.find(rm)==std::string::npos) ){
    return 1;
  }else{
    return 0;
  }
}

// ---------------------------------------- //
int write_to_file(int isfq, string name, string seq, string comment="", string qual="", string otype=""){
// ---------------------------------------- //
  char fq[5]={"@"};
  char fa[5]={">"};

  int writefq=0;
	  
  if( otype == "same" ){ 
    writefq=isfq;
  }else if(isfq && !qual.empty()){
    writefq=1;
  }else{
    cout << " write: Error! trying to write a fastq but quality string is empty! " << endl;
    return 1;
  }

  // First Line Seq Name
  if(!writefq)outfile << fa << name;
  else outfile << fq << name;
  // Comment
  if (!comment.empty())
    outfile << " " << comment <<endl;
  else 
    outfile << endl;

  // Second Line: Sequence
  outfile << seq << endl;
  
  // Fastq: Third and Fourth Lines: Qualities
  if(writefq)
    outfile << "+" << endl << qual << endl;

  return 0;
}


// ---------------------------------------- //
std::pair<string, string>  get_seq_name(string seq_name_line)
// ---------------------------------------- //
{
  string name;
  string comment; 

  size_t ns=0;
  size_t nt=0;
  ns=seq_name_line.find(" ");
  nt=seq_name_line.find("\t");
  
  if(ns!=std::string::npos) { 
    name=seq_name_line.substr(1,ns);
    comment=seq_name_line.substr(ns+1,seq_name_line.size());
  }else if(nt!=std::string::npos) {
    name=seq_name_line.substr(1,nt);
    comment=seq_name_line.substr(nt+1,seq_name_line.size());
  }else{
    name=seq_name_line.erase(0,1);
  }	

  name.erase( std::remove(name.begin(), name.end(), ' '), name.end() );

  
  return std::make_pair(name, comment);
}



// ---------------------------------------- //
int check_fast_type(string seq_name)
// ---------------------------------------- //
{
  
  return seq_name.find_first_not_of(" ");
}


// ---------------------------------------- //
int readfastaq(char* file, int saveinfo=0, int readseq=0, int saveseq=0, int minlen=0, int maxlen=0, string selctg="", string otype="", int remove_comments=0, string keep="", string rm="")
// ---------------------------------------- //
{ 
  igzstream infile(file);

  char fq[5]={"@"};
  char fa[5]={">"};
  char plus[5]={"+"};

  int isfq=0;
  int nseq=0;

  rlen.reserve(100000);
  rname.reserve(100000);
  if(saveseq) rseq.reserve(100000);

  string read;
  string lname;
  string lcomment="";   
  string lseq="";
  int seqlen=0;
  int seqlines=0;
  int first_char_idx;

  // Fastq:
  int quallen=0; 
  string lqual=""; // remains empty if fasta, otherwise is filled

  int stop=1;
  while(stop){
    getline(infile,read);

    // Check if fasta-or-fastq at the First Sequence-Name Line  (First Line)
    if(nseq==0){
      first_char_idx = check_fast_type( read );
      if( read.substr(first_char_idx, first_char_idx + 1) == fa ) isfq=0 ;
      else if (  read.substr(first_char_idx, first_char_idx + 1) == fq ) isfq=1;
      else{ cout <<first_char_idx << " " <<  read.substr(first_char_idx, first_char_idx + 1) << endl;
	cout << "Error, cannot determine if file is fasta or fastq" << endl; return 1;}

    }

    
    // Start With the Sequence-Name Line
    if(read.substr(first_char_idx, first_char_idx + 1) == fa || read.substr(first_char_idx, first_char_idx + 1) == fq) { 
 
      // Number of Sequences
      nseq++;

      // Get Previous Sequence if Passes Cuts
      if(nseq>1){	
	if(check_cuts(seqlen, lname, minlen, maxlen, selctg, keep, rm) ){  
	  // Passed Cuts: Get Sequence
	  
	  if(saveinfo)
	    fill_vectors(lname,seqlen,lseq,lcomment,lqual);  // lseq, lcomment and lqual should be empty if not explicitely used!
	  
	  if(outfile.is_open())
	    write_to_file(isfq, lname, lseq, lcomment, lqual, otype);

	}else{
	  // Did Not Passed Cuts: Excluded
	  excluded.push_back(seqlen);
	}
      }
      
      // Start Processing New Sequence

      // Re-initialize Sequence, Sequence Length and Qual length
      if(readseq)lseq="";
      if(readseq)lqual="";
      seqlen=0;
      seqlines=0;
      quallen=0;

      // Get Seq Name and possibly Comment
      std::tie(lname,lcomment) = get_seq_name(read); 
      if(remove_comments) lcomment="";

    //If is a Fastq, Read as Qual Lines the Same Number of Seq Lines
    }else if(isfq && read.substr(0,1)==plus){ 
   
      for(int ll=0; ll<seqlines; ll++){
	getline(infile,read);
	if(readseq)lqual.append(read);
	quallen+=read.size();
      }
      if ( quallen != seqlen ) {
	cout << " ERROR! seq length different from quality lenght!! " 
	     << " " << nseq << " " << seqlen << " " << quallen << " " 
	     << seqlines 
	     << endl;
	return 1;
      }

    // Is not a Read-Name Line 
    }else{ 
      if(readseq)lseq.append(read);
      seqlen+=read.size();
      seqlines++;
    }
 

    // EOF

    // Get Last Sequence if Passes Cuts
    if(infile.eof()){ 
      if(check_cuts(seqlen, lname, minlen, maxlen, selctg, keep, rm) ){  
	// Passed Cuts: Get Sequence
	if(saveinfo) fill_vectors(lname,seqlen,lseq,lcomment,lqual);
	
	if(outfile.is_open()) write_to_file(isfq, lname, lseq, lcomment, lqual, otype);
	                      

      }else{
	// Did Not Passed Cuts: Excluded
	excluded.push_back(seqlen);
      }

      // That Was The Last Sequence
      stop=0;
    }

  }//read loop
  return 0;
}


// ---------------------------------------- //
// numeric to string
// ---------------------------------------- //
template <class T>
inline std::string to_string (const T& t)
{
  std::stringstream ss;
  ss << t;
  return ss.str();
}
// ---------------------------------------- //
// string of numbers to int 
// ---------------------------------------- //
template <class T1>
inline int to_int (const T1& t)
{
  int ii;
  std::stringstream ss(t);
  ss >> ii;
  return ii;
}
// ---------------------------------------- //
// string of numbers to int 
// ---------------------------------------- //
template <class T2>
inline int to_float (const T2& t)
{
  float ii;
  std::stringstream ss(t);
  ss >> ii;
  float rr=ii*100.;
  return rr;
}



// ---------------------------------------- //
int readctglist(char* file)
// ---------------------------------------- //
{ 
  igzstream infile(file);
  string read;

  int stop=1;
  while(stop){
    getline(infile,read);
    if(!infile.eof()){
      avoid.push_back(read);
    }else{
      stop=0;
    }
  }
}


// ---------------------------------------- //
std::tuple<long int, int, float, long int, long int, int>  calcstats(vector<int> lengths)
// ---------------------------------------- //
// used by n50.cpp, 
{
  sort(lengths.begin(),  lengths.end(), std::greater<int>());

  int n=lengths.size();
  long int max=lengths[0];                 	
  long int  bases = accumulate(lengths.begin(), lengths.end(), 0.0);
  float mean = bases*1. / n;

  int n50=0;
  long int l50=0;
  int done=0;
  long int t50=0;
  int ii=0;
  while(done<1){
    t50+=lengths[ii];
    if(t50 > bases*0.5) 
      done=1;
    ii++;
   }

  n50=ii;
  l50=lengths[n50-1];  //counting from 0
  
  if(0)
    std::cout << std::fixed << std::setprecision(0) <<  "Bases= " << bases << " contigs= "
	      << n << " mean_length= " 
	      << mean << " longest= " << max << " N50= "<< l50 << " n= " << n50   //counting from 1
	      << std::endl;  

  return std::make_tuple(bases,n,mean, max, l50, n50);
}
