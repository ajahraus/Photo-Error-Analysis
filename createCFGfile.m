function createCFGfile(filename)

fileID = fopen(filename,'w');

fprintf(fileID, '; FEMBUN configuration file of default settings.\n');
fprintf(fileID, '; Image coordinate observation default standard deviations.\n');
fprintf(fileID, 'IMGX = 0.0016    ; x coordinate, pixel/3 (according to literature)\n');
fprintf(fileID, 'IMGY = 0.0016   ; y coordinate, pixel/3\n');
fprintf(fileID, ';\n');
fprintf(fileID, ';  Default maximum number of iterations.\n');
fprintf(fileID, ';\n');
fprintf(fileID, 'ITER=20\n');
fprintf(fileID, ';\n');
fprintf(fileID, ';  Default decimal place precision in output file\n');
fprintf(fileID, ';\n');
fprintf(fileID, 'PREC = 3 ;\n');
fprintf(fileID, ';\n');
fprintf(fileID, ';  Default convergence criteria\n');
fprintf(fileID, ';\n');
fprintf(fileID, 'TOL = 0.001  1.0e-5  0.001  1.0e-9 ;\n');
fprintf(fileID, ';\n');
fprintf(fileID, ';  Default data snooping value.\n');
fprintf(fileID, ';\n');
fprintf(fileID, 'DSNOOP = 0.001 0.20\n');
fprintf(fileID, ';\n');
fprintf(fileID, 'ALPHA = 0.05\n');
fprintf(fileID, ';\n');
fprintf(fileID, 'F_SD = 0.01 ;\n');
fprintf(fileID, ';\n');
fprintf(fileID, 'NUM_ELEM = 36\n');
fprintf(fileID, ';\n');
fprintf(fileID, 'PARAMS = K1 K2 K3  P1 P2\n');
fprintf(fileID, ';\n');
fprintf(fileID, 'NUM_CLASS= 16\n');
fprintf(fileID, 'SD_RHO = 1.0\n');
fprintf(fileID, 'MOD_FREQ = 20\n');
fprintf(fileID,'\n');

fclose(fileID);
end