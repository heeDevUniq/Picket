$(document).on('submit', '.vex-dialog-form', function(e){
    console.log('vex 모달 form submit 막음!');
    e.preventDefault();
    return false;
});
const com = {
    ajaxForm(type, url, formId, callback) {
        const form = document.querySelector("#" + formId);
        const formData = new FormData(form);
        const json = Object.fromEntries(formData.entries());
        $.ajax({
            url: url,
            method: type,
            contentType: 'application/json',
            data: JSON.stringify(json),
            success: function(result) {
                if (callback) callback(result);
            }
        });
    },

    ajaxParams(type, url, params, callback) {
        $.ajax({
            url: url,
            method: type,
            contentType: 'application/json',
            data: JSON.stringify(params),
            success: function(result) {
                if (callback) callback(result);
            }
        });
    },

    locateUrl(url, obj) {
        if(!url) {
            alert("URL값은 필수입니다.");
            return false;
        }
        if(!obj) obj = {};
        let form = $("<form method='POST' action='" + url + "'>");
        Object.keys(obj).map(key => {
            form.append($("<input type='hidden'/>").attr({
                "name": key,
                "value": obj[key]
            }));
        });
        form.appendTo("body").submit().remove();
    }
}