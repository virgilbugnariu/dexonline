{extends "layout-admin.tpl"}

{block "title"}
  Procesează donații
{/block}

{block "content"}
  <h3>Procesează donații</h3>

  <form class="form" method="post">
    {if $includeOtrs}
      <input type="hidden" name="includeOtrs" value="1">
    {/if}

    {if !empty($otrsDonors)}
      <div class="panel panel-default">
        <div class="panel-heading">Donații OTRS</div>
        <div class="panel-body">
          {foreach $otrsDonors as $donor}
            <h4>Donație de la {$donor->email}, {$donor->amount} de lei, {$donor->date}</h4>

            <div class="checkbox">
              <label>
                <input type="checkbox" name="processTicketId[]" value="{$donor->ticketId}" checked>
                salvează donația și închide tichetul
              </label>
            </div>

            {if $donor->needsEmail() == Donor::EMAIL_YES}
              <div class="checkbox">
                <label>
                  <input type="checkbox" name="messageTicketId[]" value="{$donor->ticketId}" checked>
                  trimite un mesaj cu textul:
                </label>
              </div>

              <div class="well">
                {$donor->htmlMessage}
              </div>
              <pre>{$donor->textMessage}</pre>
            {else}
              <p class="text-muted">
                {$donor->getEmailReason()}
              </p>
            {/if}
          {/foreach}
        </div>
      </div>
    {/if}

    {if count($manualDonors)}
      <div class="panel panel-default">
        <div class="panel-heading">Donații introduse manual</div>
        <div class="panel-body">
          {foreach $manualDonors as $i => $donor}
            <h4>Donație de la {$donor->email}, {$donor->amount} de lei, {$donor->date}</h4>

            <input type="hidden" name="email[]" value="{$donor->email}">
            <input type="hidden" name="amount[]" value="{$donor->amount}">
            <input type="hidden" name="date[]" value="{$donor->date}">

            {if $donor->needsEmail() == Donor::EMAIL_YES}
              <div class="checkbox">
                <label>
                  <input type="checkbox" name="manualSendMessage_{$i}" value="1" checked>
                  trimite un mesaj cu textul:
                </label>
              </div>

              <div class="well">
                {$donor->htmlMessage}
              </div>
              <pre>{$donor->textMessage}</pre>
            {else}
              <p class="text-muted">
                {$donor->getEmailReason()}
              </p>
            {/if}
          {/foreach}
        </div>
      </div>
    {/if}

    {if empty($otrsDonors) && empty($manualDonors)}
      <p>
        Nimic de făcut.
      </p>
    {/if}

    <div>
      {if !empty($otrsDonors) || !empty($manualDonors)}
        <button type="submit" class="btn btn-success" name="processButton">
          <i class="glyphicon glyphicon-ok"></i>
          procesează
        </button>
      {/if}

      <button type="submit" class="btn btn-default" name="backButton">
        <i class="glyphicon glyphicon-arrow-left"></i>
        înapoi
      </button>
    </div>

  </form>
{/block}
