function ajax(type, url, params) {
    let xhr = new XMLHttpRequest();
    xhr.open(type, url, true);
    xhr.setRequestHeader('Content-Type', 'application/json');
    xhr.onreadystatechange = function () {
        if (xhr.readyState === 4 && xhr.status === 200) {
            console.log('응답 데이터:', xhr.responseText);
        }
    };
    xhr.send(params);
}