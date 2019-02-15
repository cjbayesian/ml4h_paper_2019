"""Extract text to convert pdfs to text files."""

import os
import re
import subprocess
import sys


inpath = sys.argv[1]
outpath = sys.argv[2]

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print('Usage: {} <pdf path> <txt path>'.format(sys.argv[0]))
    fnames = [f for f in os.listdir(inpath) if f.endswith('.pdf')]
    txt_names = [f for f in os.listdir(outpath) if f.endswith('.txt')]

    f_roots = [f[:-4] for f in fnames]
    t_roots = [f[:-4] for f in txt_names]
    f_roots = list(set(f_roots) - set(t_roots))
    fnames = [f + '.pdf' for f in f_roots]
    fnames = [
        f for f in fnames
        if os.stat(os.path.join(inpath, f)).st_size > 0]

    n_files = len(fnames)
    for i, f in enumerate(fnames):
        if (i % int(n_files / 10)) == 0:
            print("{0:.0%} complete".format(i / n_files))

        clean_name = re.sub(' \([0-9]\)', '', f)
        os.rename(os.path.join(inpath, f),
                  os.path.join(inpath, clean_name))

        bashCommand = ['pdftotext']
        bashCommand.append(os.path.join(inpath, clean_name))
        bashCommand.append(os.path.join(outpath, clean_name[:-4]) + '.txt')
        process = subprocess.Popen(bashCommand, stdout=subprocess.PIPE)
        output, error = process.communicate()
