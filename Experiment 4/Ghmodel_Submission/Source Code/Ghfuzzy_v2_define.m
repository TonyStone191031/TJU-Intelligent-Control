% This function is to define Ghfuzzy_v5.fis through the code.

fis = mamfis('Name',"Ghfuzzy_v5");

fis = addInput(fis,[10,40],'Name',"T_in_pred");
fis = addMF(fis,"T_in_pred","gauss2mf",[0.9585,10,0.9585,13],'Name',"NB");
fis = addMF(fis,"T_in_pred","trimf",[13,15,20],'Name',"NS");
fis = addMF(fis,"T_in_pred","trimf",[17.5,21.5,23],'Name',"ZE");
fis = addMF(fis,"T_in_pred","trimf",[21,23.5,25],'Name',"PS");
fis = addMF(fis,"T_in_pred","gauss2mf",[1.019,26.5,2.378,40],'Name',"PB");

fis = addInput(fis,[-10,10],'Name',"dT_out");
fis = addMF(fis,"dT_out","trapmf",[-15.25,-10.25,-2.5,-1],'Name',"NB");
fis = addMF(fis,"dT_out","trimf",[-2,-1,0],'Name',"NS");
fis = addMF(fis,"dT_out","trimf",[-0.5,0,0.5],'Name',"ZE");
fis = addMF(fis,"dT_out","trimf",[0,1,2],'Name',"PS");
fis = addMF(fis,"dT_out","trapmf",[1,2.5,10.25,15.25],'Name',"PB");

fis = addOutput(fis,[-200,200],'Name',"Q_coef");
fis = addMF(fis,"Q_coef","gauss2mf",[45.32,-250.2,20,-120],'Name',"NB");
fis = addMF(fis,"Q_coef","trimf",[-100,-68,-30],'Name',"NS");
fis = addMF(fis,"Q_coef","trimf",[-40,0,40],'Name',"ZE");
fis = addMF(fis,"Q_coef","trimf",[30,80,140],'Name',"PS");
fis = addMF(fis,"Q_coef","gauss2mf",[37.38,169,45.32,230],'Name',"PB");

ruleList = [1 1 5 1 1;
            1 2 5 1 1'
            1 3 5 1 1;
            1 4 4 1 1;
            1 5 3 1 1;
            
            2 1 5 1 1;
            2 2 4 1 1;
            2 3 4 1 1;
            2 4 2 1 1;
            2 5 1 1 1;
            
            3 1 5 1 1;
            3 2 4 1 1;
            3 3 3 1 1;
            3 4 3 1 1;
            3 5 1 1 1;
            
            4 1 3 1 1;
            4 2 2 1 1;
            4 3 2 1 1;
            4 4 2 1 1;
            4 5 1 1 1;
            
            5 0 1 1 1];

fis = addRule(fis,ruleList);
fis.DefuzzificationMethod = 'centroid';
writeFIS(fis,'Ghfuzzy_v5');
