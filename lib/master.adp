<master>
<property name="title">@title;noquote@</property>
<property name="header_stuff">
  <style>
  .bookshelf_navbar { font-family: tahoma,verdana,arial,helvetica; font-size: 70%; font-weight: bold; color: #ccccff; text-decoration: none; }
  A.bookshelf_navbar { color: white; }
  .bookshelf_navbar:hover { color: white; text-decoration: underline;  }
  INPUT.bookshelf_navbar { font-family: tahoma,verdana,arial,helvetica; font-weight: bold; font-size: 70%; color: black; }
  .bookshelf_summary { font-size: 70%; font-family: verdana,arial,helvetica; }
  .bookshelf_summary_bold { font-size: 70%; font-family: verdana,arial,helvetica; font-weight: bold; }
  </style>
</property>
<if @signatory@ not nil><property name="signatory">@signatory</property></if>
<if @focus@ not nil><property name="focus">@focus;noquote@</property></if>
<if @context_bar@ not nil><property name="context_bar">@context_bar;noquote@</property></if>
<if @context@ not nil><property name="context">@context;noquote@</property></if>

<include src="nav-bar">

<p>

<slave>

<p>

<include src="nav-bar">
