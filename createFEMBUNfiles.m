function createFEMBUNfiles(filename, images, points)
    createINPfile([filename,'.inp'],images,points);
    createPHOfile([filename,'.pho'],images);
    createCFGfile([filename,'.cfg'])
end