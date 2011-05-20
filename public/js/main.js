$(function(){
  $('a[method=delete]').live('click', function(event) {
    if ( confirm("Are you sure?") )
        $('<form method="post" action="' + this.href + '" />')
            .append('<input type="hidden" name="_method" value="delete" />')
            .appendTo('body')
            .submit()
    return false
  })
})