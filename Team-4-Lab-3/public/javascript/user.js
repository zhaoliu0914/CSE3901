document.getElementById("user_role_student").addEventListener("click", function () {
    document.getElementById("user_status").value = "approved";
});

document.getElementById("user_role_instructor").addEventListener("click", function () {
    document.getElementById("user_status").value = "waiting";
});

document.getElementById("user_role_admin").addEventListener("click", function () {
    document.getElementById("user_status").value = "waiting";
});
