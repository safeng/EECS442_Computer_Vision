[F1,dist1_1,dist1_2]=FMat('set1/pt_2D_1.txt','set1/pt_2D_2.txt','set1/image1.jpg','set1/image2.jpg') % without normalization
[F2,dist2_1,dist2_2]=FMat('set2/pt_2D_1.txt','set2/pt_2D_2.txt','set2/image1.jpg','set2/image2.jpg') % without normalization
[F1_norm,dist1_1_norm,dist1_2_norm]=FMatNorm('set1/pt_2D_1.txt','set1/pt_2D_2.txt','set1/image1.jpg','set1/image2.jpg') % with normalization
[F2_norm,dist2_1_norm,dist2_2_norm]=FMatNorm('set2/pt_2D_1.txt','set2/pt_2D_2.txt','set2/image1.jpg','set2/image2.jpg') % with normalization