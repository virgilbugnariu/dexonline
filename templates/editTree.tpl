{extends file="layout.tpl"}

{block name=banner}{/block}
{block name=search}{/block}

{block name=title}
  {if $t->id}
    Arbore {$t->description}
  {else}
    Arbore nou
  {/if}
{/block}

{block name=content}
  <h3>
    {if $t->id}
      Editează arborele
    {else}
      Adaugă un arbore
    {/if}
  </h3>

  {* Allow the JS editor to run *}
  <div id="editable" style="display: none"></div>

  {* Stem meaning editor that we clone whenever we append a new meaning *}
  <ul id="stemNode">
    <li>
      <div class="meaningContainer">
        <span class="id"></span>
        <span class="bc"></span>
        <span class="tags"></span>
        <span class="tagIds"></span>
        <span class="internalRep"></span>
        <span class="htmlRep"></span>
        <span class="internalEtymology"></span>
        <span class="htmlEtymology"></span>
        <span class="internalComment"></span>
        <span class="htmlComment"></span>
        <span class="sources"></span>
        <span class="sourceIds"></span>
        {for $type=1 to Relation::NUM_TYPES}
          <span class="relation" data-type="{$type}"></span>
          <span class="relationIds" data-type="{$type}"></span>
        {/for}
      </div>
    </li>
  </ul>

  <form action="editTree.php" method="post" role="form">
    <input type="hidden" name="id" value="{$t->id}">
    <input type="hidden" name="jsonMeanings" value="">

    <div class="row">
      <div class="col-md-6">
        {include "bits/fgf.tpl" field="description" value=$t->description label="descriere"}

        <div class="form-group {if isset($errors.status)}has-error{/if}">
          <label>stare</label>
          <select name="status" class="form-control">
            {foreach $statusNames as $i => $s}
              <option value="{$i}" {if $i == $t->status}selected{/if}>{$s}</option>
            {/foreach}
          </select>
          {include "bits/fieldErrors.tpl" errors=$errors.status|default:null}
        </div>
      </div>

      <div class="col-md-6">
        <div class="form-group"">
          <label for="entryIds">intrări</label>
          <select id="entryIds" name="entryIds[]" style="width: 100%" multiple>
            {foreach $entryIds as $e}
              <option value="{$e}" selected></option>
            {/foreach}
          </select>

          Tipuri de model:
          {foreach $modelTypes as $mt}
            <span class="label label-default">{$mt->modelType}</span>
          {/foreach}
        </div>
      </div>
    </div>

    {if count($relatedMeanings)}
      <div class="panel panel-default">
        <div class="panel-heading">Arbori în relație cu acesta</div>

        <table class="table table-condensed table-bordered">
          <thead>
            <tr>
              <th>arbore</th>
              <th>sens</th>
              <th>tip</th>
              <th>text</th>
            </tr>
          </thead>

          <tbody>
            {foreach $relatedMeanings as $m}
              <tr>
                <td>
                  <a href="editTree.php?id={$m->getTree()->id}">
                    {$m->getTree()->description}
                  </a>
                </td>
                <td>
                  <strong>{$m->breadcrumb}</strong>
                </td>
                <td>
                  {Relation::$TYPE_NAMES[$m->relationType]}
                </td>
                <td>
                  {$m->htmlRep}
                </td>
              </tr>
            {/foreach}
          </tbody>
        </table>
      </div>
    {/if}

    <div class="panel panel-default">
      <div class="panel-heading">Sensuri</div>
      <div class="panel-body">
        {include file="bits/meaningTree.tpl"
                 meanings=$t->getMeanings()
                 id="meaningTree"
                 editable=true}

        <div>
          {if $canEdit}
            <div class="btn-group">
              <button type="button" class="btn btn-default btn-sm" id="addMeaningButton"
                      title="Adaugă un sens ca frate al sensului selectat. Dacă nici un sens nu este selectat, adaugă un sens la sfârșitul listei.">
                adaugă sens
              </button>
              <button type="button" class="btn btn-default btn-sm" id="addSubmeaningButton" disabled
                      title="Adaugă un sens ca ultimul fiu al sensului selectat">
                adaugă subsens
              </button>
              <button type="button" class="btn btn-danger btn-sm" id="deleteMeaningButton" disabled
                      title="Șterge sensul selectat">
                <i class="glyphicon glyphicon-trash"></i>
                șterge sens
              </button>
            </div>

            <div class="btn-group">
              <button type="button" class="btn btn-default btn-sm" id="meaningLeftButton" disabled
                      title="Sensul devine fratele următor al tatălui său.">
                <i class="glyphicon glyphicon-arrow-left"></i>
              </button>
              <button type="button" class="btn btn-default btn-sm" id="meaningRightButton" disabled
                      title="Sensul devine fiu al fratelui său anterior.">
                <i class="glyphicon glyphicon-arrow-right"></i>
              </button>
              <button type="button" class="btn btn-default btn-sm" id="meaningDownButton" disabled
                      title="Sensul schimbă locurile cu fratele său următor.">
                <i class="glyphicon glyphicon-arrow-down"></i>
              </button>
              <button type="button" class="btn btn-default btn-sm" id="meaningUpButton" disabled
                      title="Sensul schimbă locurile cu fratele său anterior.">
                <i class="glyphicon glyphicon-arrow-up"></i>
              </button>
            </div>
          {/if}
        </div>
      </div>
    </div>

    {if $canEdit}
      <div class="panel panel-default">
        <div class="panel-heading">Editorul de sensuri</div>
        <div class="panel-body">

          <div class="row">

            <div class="col-md-8">
              <div class="form-group">
                <label>sens</label>
                <textarea id="editorRep" class="form-control" rows="10" disabled></textarea>
              </div>

              <div class="form-group">
                <label>etimologie</label>
                <textarea id="editorEtymology" class="form-control" rows="5" disabled></textarea>
              </div>

              <div class="form-group">
                <label>comentariu</label>
                <textarea id="editorComment" class="form-control" rows="3" disabled></textarea>
              </div>
            </div>

            <div class="col-md-4">
              <div class="form-group">
                <label for="editorSources">surse</label>
                <select id="editorSources" multiple disabled>
                  {foreach from=$sources item=s}
                    <option value="{$s->id}">{$s->shortName}</option>
                  {/foreach}
                </select>
              </div>

              <div class="form-group">
                <label for="editorTags">etichete</label>
                <select id="editorTags" multiple disabled>
                  {foreach $tags as $tag}
                    <option value="{$tag->id}">{$tag->value}</option>
                  {/foreach}
                </select>
              </div>

              <div class="form-group">
                <label>relații:</label>

                <select id="relationType" class="form-control" disabled>
                  {foreach Relation::$TYPE_NAMES as $type => $name}
                    <option value="{$type}"" title="{$name}">{$name}</option>
                  {/foreach}
                </select>

                <span class="relationWrapper" data-type="1">
                  <select class="form-control editorRelation" multiple disabled></select>
                </span>
                <span class="relationWrapper" data-type="2">
                  <select class="form-control editorRelation" multiple disabled></select>
                </span>
                <span class="relationWrapper" data-type="3">
                  <select class="form-control editorRelation" multiple disabled></select>
                </span>
                <span class="relationWrapper" data-type="4">
                  <select class="form-control editorRelation" multiple disabled></select>
                </span>
              </div>
            </div>
          </div>

          <input id="editMeaningAcceptButton" type="button" disabled value="acceptă">
          <input id="editMeaningCancelButton" type="button" disabled value="renunță">
        </div>
      </div>
    {/if}

    <div>
      <button type="submit" class="btn btn-primary" name="saveButton">
        <i class="glyphicon glyphicon-floppy-disk"></i>
        salvează
      </button>

      <button type="submit" class="btn btn-default" name="clone">
        <i class="glyphicon glyphicon-duplicate"></i>
        clonează
      </button>

      <a href="{if $t->id}?id={$t->id}{/if}">
        anulează
      </a>
    </div>
  </form>
{/block}
