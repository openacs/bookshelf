<master src="../lib/master">
  <property name="title">@page_title;noquote@</property>
  <property name="context_bar">@context_bar;noquote@</property>

<table border="0" cellpadding="0" cellspacing="0" width="100%">
  <tr>
    <td valign="top" width="200" style="border: solid 1px gray;" bgcolor="#ccccff" style="font-size: 70%; font-family: verdana,arial,helvetica; font-weight: bold;">
      <div style="padding: 4px; margin-bottom: 12px;">Summary:</div>
      <multiple name="stats">
        <table border="0" width="100%">
          <tr>
            <td colspan="2" style="font-size: 70%; font-family: verdana,arial,helvetica; font-weight: bold;">
              @stats.stat_name@
            </td>
          </tr>
          <group column="stat_name">
            <tr>
              <td width="75%" style="font-size: 70%; font-family: verdana,arial,helvetica;">
                <a href="@stats.name_url@">@stats.name@</a>
              </td>
              <td align="right" style="font-size: 70%; font-family: verdana,arial,helvetica;">
                @stats.num_books@
              </td>
            </tr>
          </group>
        </table>
        <p>
      </multiple>
    </td>
    <td width="25">&nbsp;</td>
    <td valign="top">
      <table border=0 width="100%" cellspacing="0" cellpadding="0" bgcolor="white">
        <tr>
          <td colspan="2">
            <table width="100%" style="border: solid 1px gray;" bgcolor="#ccccff" cellspacing="0" cellpadding="4" border="0">
              <tr>
                <td>
                  <b>Showing: </b> @human_readable_filter@
                  <if @clear_filters_url@ not nil>(<a href="@clear_filters_url@">clear filters</a>)</if>
                </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td colspan="2" height="16">
            <table cellspacing="0" cellpadding="0" border="0"><tr><td height="16"></td></tr></table>
          </td>
        </tr>

        <multiple name="book">
          <tr>
            <td valign=top>
              <font face="tahoma,verdana,arial,helvetica,sans-serif">
              <a href="@book.view_url@" title="View book review">@book.book_title@</a>
              <if @write_p@ true>(<a href="@book.edit_url@">Edit</a>)</if>
              <br>
              <if @book.main_entry@ not nil>@book.main_entry_html;noquote@<br /></if>
              <if @book.additional_entry@ not nil><a href="@book.view_url@">Continued...</a><br /></if>
              <font color="#6f6f6f">Reviewed by:</font> @book.creation_user_first_names@ @book.creation_user_last_name@
              <br>
              <font color="#6f6f6f">Read Status:</font>
              <font color="#008000"><b>@book.read_status_pretty@</b>
              <if @book.publish_status@ eq "draft"><br><font color="#008000">DRAFT</font></if>                
              <p>
            </td>
          </tr>
        </multiple>
        <if @book:rowcount@ eq 0>
          <tr>
            <td colspan="2">
              <p>&nbsp;<p>
              <i>No book match these criteria.</i>
            </td>
          </tr>
        </if>
      </table>
    </td>
  </tr>
</table>
