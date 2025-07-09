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
    },

    alert(msg, callback) {
        Swal.fire({
            text: msg,
            icon: "info"
        }).then(function() {
            if (callback) callback();
        });
    },

    confirm(title, msg, icon, callback) {
        Swal.fire({
            title: title,
            text: msg,
            icon: icon,
            confirmButtonText: '확인',
            allowOutsideClick: false,
            allowEscapeKey: false
        }).then(function(result) {
            if (callback) callback();
        });
    },

    chkLogin() {
        const session = false;
        if (session) {
            com.confirm('로그인 안내','해당 기능은 로그인이 필요합니다.','warnning',function() {
                location.href = "/login";
            });
        }
    }
}