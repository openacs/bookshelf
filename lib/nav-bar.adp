<if @show_navbar_p@ true>
  <div class="bookshelf_navbar">
    <multiple name="links"><a href="@links.url@">@links.name@</a><if @links.rownum@ lt @links:rowcount@>&nbsp;|&nbsp;</if>
    </multiple>
  </div>
</if>
