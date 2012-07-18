function stats =  graycoprops_Dean(glm)

stats =  graycoprops(glm);

glm2 = glm(find(glm>0));
stats.Entropy = -sum(sum(glm2.*log(glm2)));

return;