<table cellpadding="4" border="0">
  <tr>
    <th colspan="2" align="left">
      <a href="@book.url@"><em>@book.book_title@</em></a>
      by @book.book_author@
    </th>
  </tr>
  <tr>
    <td valign="top" align="left">
      <a href="@book.url@"><img src="@book.image_url@" width="@book.image_width@" height="@book.image_height@" border="0"></a> 
    </td>
    <td valign="top" align="left">
      @book.main_entry_html;noquote@
      <if @book.additional_entry@ not nil>
        <p>
          @book.additional_entry_html;noquote@
        </p>
      </if> 
      <br>
      <font size="-2" color="#999999">
        <br>
        Posted by @book.creation_user_first_names@ @book.creation_user_last_name@ on @book.creation_date_pretty@
        - <a href="@perma_url@">Permalink</a>
        <if @edit_url@ not nil> - <a href="@edit_url@">Edit</a></if>
        <if @publish_url@ not nil> - <a href="@publish_url@">Publish</a></if>
        <if @draft_url@ not nil> - <a href="@draft_url@">Draft</a></if>
      </font>
    </td>
  </tr>
</table>
