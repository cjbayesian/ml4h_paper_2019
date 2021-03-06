# ML4H 2018 NeurIPS paper analysis

## Pipeline:

Using [anaconda](https://www.anaconda.com/distribution/):

```bash
conda env create -f environment.yml
source activate ml4h_papers
jupyter notebook
```

1. Get the metadata for all papers `NeurIPS_Proceedings_Metadata.ipynb`
2. Download the pdfs `NeurIPS_Proceedings_dl_pdfs.ipynb`
3. Extract raw text from pdfs: 
```bash
python pdf2text.py ./data/ML4H2018/pdf/ ./data/ML4H2018/txt/
python pdf2text.py ./data/NeurIPS2018/pdf/ ./data/NeurIPS2018/txt/
```
4. Pre-process raw text
   - Run text pre-processing `NeurIPS_Proceedings_preprocess.ipynb` OR
   - Run the `create_r_dataset.R` script to generate `.rdata` files
5. Optional: run the example topic model and visualization script `ldavis.R`.

## Requires

### Python
- Python >= 3.7
- requests
- beautifulsoup4
- pandas
- json

### R
- tm
- LDAvis
- lda

### Other
- pdftotext version 0.64.0
