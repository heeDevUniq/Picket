const post = {

    save(postType) {
        com.confirm('등록','저장 하시겠습니까?','question',function() {
            com.ajaxForm('POST','/' + postType + '/save','postForm',function(result) {
                if (result > 0) {
                    com.alert('게시글이 저장되었습니다.');
                    location.href = '/' + postType;
                } else {
                    com.alert('게시글 저장에 실패하였습니다. 잠시 후 다시 시도해주세요.');
                }
            });
        });
    },

    delete(postType) {
        com.confirm('삭제','삭제 하시겠습니까?','question',function() {
            com.ajaxForm('POST','/' + postType + '/delete','postForm',function(data) {
                if (data > 0) {
                    com.alert('게시글이 삭제되었습니다.');
                    location.href = '/' + postType;
                } else {
                    com.alert('게시글 삭제에 실패하였습니다. 잠시 후 다시 시도해주세요.');
                }
            });
        });
    },

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