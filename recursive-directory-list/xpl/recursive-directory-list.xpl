<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" version="1.0"
  xmlns:cxf="http://xmlcalabash.com/ns/extensions/fileutils"
  xmlns:c="http://www.w3.org/ns/xproc-step"
  xmlns:tr="http://transpect.io"
  type="tr:recursive-directory-list">
  
  <p:documentation xmlns="http://www.w3.org/1999/xhtml">
    <p>Copied from http://xproc.org/library/recursive-directory-list.xpl</p>
    <p>Changed the namespace prefix from l to tr (and the namespaces accordingly).</p>
    <p>Prepended a cxf:info step because the step would fail sometimes with Calabash 1.1.4 even if there was a try/catch around it.</p>
    <p>Copyright situation unclear.</p>
  </p:documentation>

  <p:output port="result"/>
  <p:option name="path" required="true"/>
  <p:option name="include-filter"/>
  <p:option name="exclude-filter"/>
  <p:option name="depth" select="-1"/>

  <p:import href="http://xmlcalabash.com/extension/steps/library-1.0.xpl"/>

  <cxf:info fail-on-error="false">
    <p:with-option name="href" select="$path"/>
  </cxf:info>

  <p:choose>
    <p:when test="/c:directory">
      <p:choose>
    <p:when test="p:value-available('include-filter')
                  and p:value-available('exclude-filter')">
      <p:directory-list>
        <p:with-option name="path" select="$path"/>
        <p:with-option name="include-filter" select="$include-filter"/>
        <p:with-option name="exclude-filter" select="$exclude-filter"/>
      </p:directory-list>
    </p:when>

    <p:when test="p:value-available('include-filter')">
      <p:directory-list>
        <p:with-option name="path" select="$path"/>
        <p:with-option name="include-filter" select="$include-filter"/>
      </p:directory-list>
    </p:when>

    <p:when test="p:value-available('exclude-filter')">
      <p:directory-list>
        <p:with-option name="path" select="$path"/>
        <p:with-option name="exclude-filter" select="$exclude-filter"/>
      </p:directory-list>
    </p:when>

    <p:otherwise>
      <p:directory-list>
        <p:with-option name="path" select="$path"/>
      </p:directory-list>
    </p:otherwise>
  </p:choose>

  <p:viewport match="/c:directory/c:directory">
    <p:variable name="name" select="/*/@name"/>

    <p:choose>
      <p:when test="$depth != 0">
        <p:choose>
          <p:when test="p:value-available('include-filter')
                        and p:value-available('exclude-filter')">
            <tr:recursive-directory-list>
              <p:with-option name="path" select="concat($path,'/',$name)"/>
              <p:with-option name="include-filter" select="$include-filter"/>
              <p:with-option name="exclude-filter" select="$exclude-filter"/>
              <p:with-option name="depth" select="$depth - 1"/>
            </tr:recursive-directory-list>
          </p:when>

          <p:when test="p:value-available('include-filter')">
            <tr:recursive-directory-list>
              <p:with-option name="path" select="concat($path,'/',$name)"/>
              <p:with-option name="include-filter" select="$include-filter"/>
              <p:with-option name="depth" select="$depth - 1"/>
            </tr:recursive-directory-list>
          </p:when>

          <p:when test="p:value-available('exclude-filter')">
            <tr:recursive-directory-list>
              <p:with-option name="path" select="concat($path,'/',$name)"/>
              <p:with-option name="exclude-filter" select="$exclude-filter"/>
              <p:with-option name="depth" select="$depth - 1"/>
            </tr:recursive-directory-list>
          </p:when>

          <p:otherwise>
            <tr:recursive-directory-list>
              <p:with-option name="path" select="concat($path,'/',$name)"/>
              <p:with-option name="depth" select="$depth - 1"/>
            </tr:recursive-directory-list>
          </p:otherwise>
        </p:choose>
      </p:when>
      <p:otherwise>
	<p:identity/>
      </p:otherwise>
    </p:choose>
  </p:viewport>

</p:when>

    <p:otherwise>
      <p:string-replace match="href" >
        <p:with-option name="replace" select="concat('''', $path, '''')"/>
        <p:input port="source">
          <p:inline>
            <c:error code="l:NODIR">
              <href/>
            </c:error>
          </p:inline>
        </p:input>
      </p:string-replace>
    </p:otherwise>
  </p:choose>

</p:declare-step>