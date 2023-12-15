def clear_nas_python(df):

    #clean number of rows
    print("Number of rows raw: "+str(len(df)))
    
    #remove nas
    df = df.dropna()
    
    #clean number of rows
    print("Number of rows clean: "+str(len(df)))

    return(df)