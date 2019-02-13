# ML4H 2018 NeurIPS paper analysis

## Pipeline:

Using conda:

```bash
conda env create -f environment.yml
source activate ml4h_papers
jupyter notebook
```

1. Get the metadata for all papers `NeurIPS_Proceedings_Metadata.ipynb`
2. Download the pdfs `NeurIPS_Proceedings_dl_pdfs.ipynb`
3. Extract raw text from pdfs `NeurIPS_Proceedings_pdf2text.ipynb`
4. Run text pre-processing `NeurIPS_Proceedings_preprocess.ipynb`

## Requires

### Python
- Python >= 3.7
- requests
- beautifulsoup4
- pandas
- json

### Other
- pdftotext version 0.64.0
