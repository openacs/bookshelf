<if @show_navbar_p@ true>
  <table border=0" cellspacing="0" cellpadding="2" bgcolor="#41329c" width="100%">
    <tr>
      <td align="right">
        <multiple name="links">
          <a href="@links.url@" class="bookshelf_navbar">@links.name@</a>
          <if @links.rownum@ lt @links:rowcount@><span class="bookshelf_navbar">&nbsp;|&nbsp;</span></if>
        </multiple>
        &nbsp;&nbsp;
      </td>
    </tr>
  </table>
</if>