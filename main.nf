#!/usr/bin/env nextflow

params.f1 = 'file1'
params.f2 = false

if (!params.f2){
  fe = Channel.create()
  //fe = Channel.empty()
}else{
  Channel.fromPath(params.f2)
    .set { fe; }
}

Channel.fromPath(params.f1)
  .set { f1; }


process p1 {

    input:
    file file1 from f1
    
    output:
    file 'file2' into f2

    """
    cp $file1 file2
    """
}


process pe {

    when:
    params.f2
    
    input:
    file filee from fe
    
    output:
    file 'file3' into f3

    """
    cp $filee file3
    """
}


process p2 {

    input:
    file file2 from f2
    file file3 from f3.ifEmpty([])
    
    output:
    file 'file4' into f4

    """
    echo $file2 $file3 > file4
    """
}
