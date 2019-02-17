create_r_dataset <- function(path, outfile="data/papers.rdata"){
    files <- list.files(path)
    list.condition <- sapply(files, function(x) substr(x, nchar(x)-3, nchar(x)) =='.txt')
    txt.files <- file.path(path, files)
    txt <- lapply(txt.files, readLines)
    papers <- setNames(txt, files)
    papers <- sapply(papers, function(x) paste(x, collapse = " "))
    save(papers, file = outfile, compress = "xz")
}

create_r_dataset("data/ML4H2018/txt",outfile="data/ML4H2018.rdata")
create_r_dataset("data/NeurIPS2018/txt",outfile="data/NeurIPS2018.rdata")
