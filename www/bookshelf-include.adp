<multiple name="book">
  <if @limit@ nil>
  <h3>@book.read_status_pretty@</h3>
  </if>
  <group column="read_status">
    <div style="border-bottom:1px dashed #3366cc;">
      <include src="book-chunk" &book="book">
    </div>
  </group>
</multiple>
