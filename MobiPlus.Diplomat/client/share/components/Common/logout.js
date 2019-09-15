class LogoutUser {
    removeState() {
        var data = JSON.parse(sessionStorage.user);
        if (!data) return;
        location.reload(true);
        sessionStorage.clear();
    } 
};

export default () => {
    var user = new LogoutUser();
    user.removeState();
}