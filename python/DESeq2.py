#!/usr/bin/env python3

import sys

import numpy as np
import rpy2
import rpy2.robjects as robjects
import rpy2.robjects as ro
from rpy2.robjects import Formula, pandas2ri
from rpy2.robjects.conversion import localconverter
from rpy2.robjects.packages import importr

pandas2ri.activate()

deseq = importr("DESeq2")
to_dataframe = robjects.r("function(x) data.frame(x)")


class DESeq2:
    """
    DESeq2 object through rpy2
    input:
    count_matrix: should be a pandas dataframe with each column as count, and a id column for gene id
        example:
        id    sampleA    sampleB
        geneA    5    1
        geneB    4    5
        geneC    1    2
    design_matrix: an design matrix in the form of pandas dataframe, see DESeq2 manual, samplenames as rownames
                treatment
    sampleA1        A
    sampleA2        A
    sampleB1        B
    sampleB2        B
    design_formula: see DESeq2 manual, example: "~ treatment""
    gene_column: column name of gene id columns, exmplae "id"
    """

    def __init__(
            self, count_matrix, design_matrix, design_formula, gene_column="gene_id"
    ):
        print("you need to have R installed with the DESeq2 library installed")
        try:
            assert (
                    gene_column == count_matrix.columns[0]
            ), "no $gene_column name in 1st column's name"
            gene_id = count_matrix[gene_column]
        except AttributeError:
            sys.exit("Wrong Pandas dataframe?")
        print(rpy2.__version__)
        self.deseq_result = None
        self.resLFC = None
        self.comparison = None
        self.normalized_count_matrix = None
        self.gene_column = gene_column
        self.gene_id = count_matrix[self.gene_column]
        with localconverter(ro.default_converter + pandas2ri.converter):
            self.count_matrix = pandas2ri.py2rpy(
                count_matrix.drop(gene_column, axis=1).astype(int)
            )
            self.design_matrix = pandas2ri.py2rpy(design_matrix.astype(bool))
        self.design_formula = Formula(design_formula)
        self.dds = deseq.DESeqDataSetFromMatrix(
            countData=self.count_matrix,
            colData=self.design_matrix,
            design=self.design_formula,
        )

    def run_estimate_size_factors(self, **kwargs):  # OPTIONAL
        """
        args:
          geoMeans: cond*gene matrix
        """
        self.dds = deseq.estimateSizeFactors_DESeqDataSet(self.dds, **kwargs)

    def run_deseq(self, **kwargs):
        self.dds = deseq.DESeq(self.dds, **kwargs)

    def get_size_factors(self):
        return deseq.sizeFactors_DESeqDataSet(self.dds)

    def set_size_factors(self, factors):
        val = self.dds.do_slot("colData").do_slot("listData")
        val[2] = ro.vectors.FloatVector(np.array(factors))
        self.dds.do_slot("colData").do_slot_assign("listData", val)

    def get_deseq_result(self, **kwargs):
        self.comparison = deseq.resultsNames(self.dds)

        self.deseq_result = deseq.results(self.dds, **kwargs)
        self.deseq_result = to_dataframe(self.deseq_result)
        with localconverter(ro.default_converter + pandas2ri.converter):
            self.deseq_result = ro.conversion.rpy2py(
                self.deseq_result
            )  # back to pandas dataframe
        self.deseq_result[self.gene_column] = self.gene_id.values
