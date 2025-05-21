function signup() {
    const form = document.querySelector('form');
    const formData = new FormData(form);
    ajax('POST', '/user/api/signup', formData);
}