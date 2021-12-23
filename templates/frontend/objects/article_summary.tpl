{**
 * templates/frontend/objects/article_summary.tpl
 *
 * Copyright (c) 2014-2017 Simon Fraser University Library
 * Copyright (c) 2003-2017 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @brief View of an Article summary which is shown within a list of articles.
 *
 * @uses $article Article The article
 * @uses $hasAccess bool Can this user access galleys for this context? The
 *       context may be an issue or an article
 * @uses $showGalleyLinks bool Show galley links to users without access?
 * @uses $hideGalleys bool Hide the article galleys for this article?
 * @uses $primaryGenreIds array List of file genre ids for primary file types
 *}
{assign var=articlePath value=$article->getBestId($currentJournal)}
{if (!$section.hideAuthor && $article->getHideAuthor() == $smarty.const.AUTHOR_TOC_DEFAULT) || $article->getHideAuthor() == $smarty.const.AUTHOR_TOC_SHOW}
    {assign var="showAuthor" value=true}
{/if}

<div class="article-summary media">
    {*	{if $article->getLocalizedCoverImage()}*}
    {*		<div class="cover media-left">*}
    {*			<a href="{url page="article" op="view" path=$articlePath}" class="file">*}
    {*				<img class="media-object" src="{$article->getLocalizedCoverImageUrl()|escape}" alt="{$article->getLocalizedCoverImageAltText()|escape|default:''}">*}
    {*			</a>*}
    {*		</div>*}
    {*	{/if}*}

    <div class="media-body">
        <div style="padding-left: 0;" class="col-md-12">
            <a href="{url page="article" op="view" path=$articlePath}">
                {$article->getLocalizedTitle()|strip_unsafe_html}
                {if $article->getLocalizedSubtitle()}
                    <p>
                        <small>{$article->getLocalizedSubtitle()|escape}</small>
                    </p>
                {/if}
            </a>

            {if $showAuthor || $article->getPages()}

                {if $showAuthor}
                    <div class="meta">
                        {if $showAuthor}
                            <div class="authors" {if !$hideDOI && $pubIdPlugins} style="padding-bottom: 0;"{/if}>
                                {$article->getAuthorString()|escape}
                            </div>
                        {/if}
                    </div>
                {/if}

                {if !$hideDOI && $pubIdPlugins}
                    {foreach from=$pubIdPlugins item=pubIdPlugin}
                        {if $pubIdPlugin->getPubIdType() != 'doi'}
                            {continue}
                        {/if}
                        {if $issue->getPublished()}
                            {assign var=pubId value=$article->getStoredPubId($pubIdPlugin->getPubIdType())}
                        {else}
                            {assign var=pubId value=$pubIdPlugin->getPubId($article)} Preview pubId
                        {/if}
                        {if $pubId}
                            {assign var="doiUrl" value=$pubIdPlugin->getResolvingURL($currentJournal->getId(), $pubId)|escape}
                            <div class="doi">
                                <a href="{$doiUrl}">
                                    {$doiUrl}
                                </a>
                            </div>
                        {/if}
                    {/foreach}
                {/if}

                {if (!$hideGalleys && $article->getGalleys()) || $citation}
                    <div role="group" style="display: inline-block; padding-top: 3px;">
                        {if !$hideGalleys && $article->getGalleys()}
                            {foreach from=$article->getGalleys() item=galley}
                                {if $primaryGenreIds}
                                    {assign var="file" value=$galley->getFile()}
                                    {if !$galley->getRemoteUrl() && !($file && in_array($file->getGenreId(), $primaryGenreIds))}
                                        {continue}
                                    {/if}
                                {/if}
                                {assign var=publication value=$article->getCurrentPublication()}
                                {assign var="hasArticleAccess" value=$hasAccess}
                                {if $currentContext->getSetting('publishingMode') == $smarty.const.PUBLISHING_MODE_OPEN || $publication->getData('accessStatus') == $smarty.const.ARTICLE_ACCESS_OPEN}
                                    {assign var="hasArticleAccess" value=1}
                                {/if}
                                {include file="frontend/objects/galley_link.tpl" parent=$article hasAccess=$hasArticleAccess}
                            {/foreach}
                        {/if}
                        {if $citation}
                            <a class="galley-link btn btn-borders btn-xs btn-outline" role="button" data-toggle="modal" data-target="[id='vojsCitation.{$citationIndex}'">
                                <i class="fas fa-quote-right fa-xs"></i>
                                {translate|escape key="vojs.citation"}
                            </a>
                            <div class="modal fade" id="vojsCitation.{$citationIndex}" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
                            <div class="modal-dialog" role="document">
                                <div class="panel panel-default how-to-cite modal-content">
                                    <div class="modal-header panel-heading">
                                        <h4>{translate key="vojs.howToCite"}</h4>
                                    </div>
                                    <div class="modal-body panel-body">
                                        <div id="citationOutput.{$citationIndex}" role="region" aria-live="polite">
                                            {$citation}
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <div class="btn-group">
                                            <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown"
                                                    aria-controls="cslCitationFormats.{$citationIndex}">
                                                {translate key="vojs.howToCite.citationFormats"}
                                                <span class="caret"></span>
                                            </button>
                                            <ul class="dropdown-menu" role="menu">
                                                {foreach from=$citationStyles item="citationStyle"}
                                                    <li>
                                                        <a
                                                                aria-controls="citationOutput.{$citationIndex}"
                                                                href="{url page="citationstylelanguage" op="get" path=$citationStyle.id params=$citationArgs}"
                                                                data-load-citation="data-load-citation.{$citationIndex}"
                                                                data-json-href="{url page="citationstylelanguage" op="get" path=$citationStyle.id params=$citationArgsJson}"
                                                        >
                                                            {$citationStyle.title|escape}
                                                        </a>
                                                    </li>
                                                {/foreach}
                                                {* Download citation formats *}
                                                {if count($citationDownloads)}
                                                    <div class="panel-heading">{translate key="vojs.howToCite.downloadCitation"}</div>

                                                    {foreach from=$citationDownloads item="citationDownload"}
                                                        <li>
                                                            <a href="{url page="citationstylelanguage" op="download" path=$citationDownload.id params=$citationArgs}">
                                                                <span class="fa fa-download"></span>
                                                                {$citationDownload.title|escape}
                                                            </a>
                                                        </li>
                                                    {/foreach}
                                                {/if}
                                            </ul>
                                        </div>
                                        <button type="button" class="btn btn-secondary" id="copyBtn.{$citationIndex}" style="margin-bottom: 0; margin-left: 5px;">
                                            <span class="icon-copy-btn fas fa-copy"></span>
                                            {translate key="vojs.howToCite.copy"}
                                        </button>
                                        <button type="button" class="btn btn-secondary" data-dismiss="modal">
                                            {translate key="vojs.howToCite.close"}
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        {/if}
                    </div>
                {/if}

                {* Page numbers for this article *}
                {if $article->getPages()}
                    <a class="btn btn-borders btn-xs btn-outline" style="float:right; pointer-events:none">
                        {translate|escape key="vojs.page"}:
                        {$article->getPages()|escape}
                    </a>
                {/if}

            {/if}

        </div>

        {* <div style="padding-right: 0; text-align: end;" class="col-md-12">


        </div> *}

    </div>

    {call_hook name="Templates::Issue::Issue::Article"}
</div><!-- .article-summary -->
