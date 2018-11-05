<div class="paraLexeme">
  <div>
    <span class="lexemeName">{include "bits/lexemeName.tpl" lexeme=$lexeme}</span>

    {foreach $lexeme->getTags() as $t}
      {include "bits/tag.tpl"}
    {/foreach}

    {if User::can(User::PRIV_EDIT + User::PRIV_STRUCT)}
      <a class="btn btn-link" href="{$wwwRoot}admin/lexemeEdit.php?lexemeId={$lexeme->id}">
        <i class="glyphicon glyphicon-pencil"></i>
        editează
      </a>
    {/if}
  </div>

  <ul class="lexemeMorphology">
    {if $lexeme->hyphenations}
      <li>
        silabisire: <span class="value">{$lexeme->hyphenations}</span>
      </li>
    {/if}

    {if $lexeme->pronunciations}
      <li>
        pronunție: <span class="value">{$lexeme->getDisplayPronunciations()}</span>
      </li>
    {/if}
  </ul>

  {include "paradigm/paradigm.tpl" lexeme=$lexeme}
</div>
