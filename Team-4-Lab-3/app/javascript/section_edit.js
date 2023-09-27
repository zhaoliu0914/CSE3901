function checkGraderRequired(){
    let graderRequired = document.getElementById("grader_required_id")
    let numGradersRequired = document.getElementById("section_num_graders_required")

    if(graderRequired.val() != "yes"){
        numGradersRequired.css('display','none');
    }
    else{
        numGradersRequired.css('display','block');
    }

    graderRequired.change(function(){
        if($(this).val() != "yes"){
            numGradersRequired.css('display','none');
        }
        else{
            numGradersRequired.css('display','block');
        }
    })
}

