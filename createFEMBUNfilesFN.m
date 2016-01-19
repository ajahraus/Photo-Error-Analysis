function createFEMBUNfilesFN(filename, images, points)
    createINPfileFreeNetwork([filename,'.inp'],images,points);
    createPHOfile([filename,'.pho'],images);
    createCFGfile([filename,'.cfg'])
end