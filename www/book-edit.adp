<master src="../lib/master">
<property name="title">@page_title;noquote@</property>
<property name="context">@context;noquote@</property>
<property name="focus">book.isbn</property>

<script language="javascript">
   function isbn_update() {
      document.forms['book'].elements['__refreshing_p'].value = 1;
      document.forms['book'].elements['__isbn_update_flag'].value = 1;
      document.forms['book'].submit();
   }
</script>

<if @image_url@ not nil>
  <a href="@book_url@"><img src="@image_url@" border="0" align="right"></a>
</if>

<if @delete_url@ not nil><p><a href="@delete_url@">Delete this book review</a></p></if>

<formtemplate id="book"></formtemplate>

