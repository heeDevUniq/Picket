document.addEventListener('DOMContentLoaded', function() {
   event.preventDefault();
});
const com = {
    ajax(type, url, formId, msg) {
        const form = document.querySelector(formId);
        const formData = new FormData(form);
        const json = Object.fromEntries(formData.entries());
        $.ajax({
            url: url,
            method: type,
            contentType: 'application/json',
            data: JSON.stringify(json),
            success: function(result) {
                console.log(result);
                alert(msg);
            }
        });
    }
}