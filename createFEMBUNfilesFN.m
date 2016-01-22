function createFEMBUNfilesFN(filename, images, points)
    createINPfileFreeNetwork(['C:\\FEMBUN2016\\',filename,'.inp'],images,points);
    createPHOfile(['C:\\FEMBUN2016\\',filename,'.pho'],images);
    createCFGfile(['C:\\FEMBUN2016\\',filename,'.cfg'])
end