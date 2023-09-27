function addCourse(subPage){
    let courses = document.getElementById("interestedCourses"+ subPage + "Id");
    let div = document.createElement("div");
    div.className = "input-group mb-3";
    let content = "<span class=\"input-group-text\" id=\"basic-addon3\">CSE </span>";
    content = content + "<input type=\"text\" id=\"basic-form-input\" class=\"form-control\" aria-describedby=\"basic-addon3\" name=\"application[interestedCourses][]\">";
    div.innerHTML = content;
    courses.appendChild(div);
}

