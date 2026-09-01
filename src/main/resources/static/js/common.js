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
            },
            error: function(xhr) {
                com.ajaxError(xhr);
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
            },
            error: function(xhr) {
                com.ajaxError(xhr);
            }
        });
    },

    ajaxError(xhr) {
        // 로그인이 필요하면 안내 없이 바로 이동, 돌아올 주소를 남긴다
        if (xhr && xhr.status === 401) {
            location.href = '/login?returnUrl=' + encodeURIComponent(location.pathname + location.search);
            return;
        }
        com.alert('처리 중 오류가 발생하였습니다. 잠시 후 다시 시도해주세요.');
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
            icon: "info",
            scrollbarPadding: false
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
            cancelButtonText: '취소',
            showCancelButton: true,
            allowOutsideClick: false,
            allowEscapeKey: false,
            scrollbarPadding: false
        }).then(function(result) {
            if (result.isConfirmed) {
                if (callback) callback();
            }
        });
    },

    chkLogin(isLogin) {
        if (!isLogin) {
            location.href = '/login?returnUrl=' + encodeURIComponent(location.pathname + location.search);
            return false;
        }
        return true;
    }
}