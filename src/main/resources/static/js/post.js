const post = {

    save(postType) {
        com.ajaxForm('POST','/' + postType + '/save','postForm',function(result) {
            if (result.postId > 0) {
                Swal.fire('글이 등록되었습니다.');
                location.href = '/' + postType;
            } else {
                Swal.fire('글 등록에 실패하였습니다. 잠시 후 다시 시도해주세요.');
            }
        });
    }

}

 $(document).ready(function() {
    $('#summernote').summernote({
        height: 300, placeholder: '내용을 입력하세요.',
        toolbar: [
        ['style', ['style']],
        ['font', ['bold', 'italic', 'underline', 'clear']],
        ['fontsize', ['fontsize']],
        ['color', ['color']],
        ['para', ['ul', 'ol', 'paragraph']],
        ['table', ['table']],
        ['insert', ['link']],
        ['view', ['fullscreen', 'codeview', 'help']]
        ]
    });
});