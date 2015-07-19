function [ MOut, LambdaOut, PsiOut ] = initSubstrate(initFlag)
    
    persistent MSave LambdaSave PsiSave
    
    if initFlag
        
        load(FKDefaults, 'M', 'Lambda', 'Psi')
        
        MSave = M;
        LambdaSave = Lambda;
        PsiSave = Psi;
        
    end
    
    MOut = MSave;
    LambdaOut = LambdaSave;
    PsiOut = PsiSave;
    
end
