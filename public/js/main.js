$(function(){
  $('a[method=delete]').live('click', function(event) {
    if ( confirm("Are you sure?") )
        $('<form method="post" action="' + this.href + '" />')
            .append('<input type="hidden" name="_method" value="delete" />')
            .appendTo('body')
            .submit()
    return false
  })
  
  $(".creations a.main_img").fancybox({overlayShow: true, transitionIn: 'elastic', transitionOut: 'fade', hideOnContentClick: true, showCloseButton: false, titleShow: false, padding: 16, changeSpeed: 800})
})