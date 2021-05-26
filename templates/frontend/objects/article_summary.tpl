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
                            <div class="authors">
                                {$article->getAuthorString()|escape}
                            </div>
                        {/if}
                    </div>
                {/if}

{*                {if !$hideDOI}*}
{*                    {foreach from=$pubIdPlugins item=pubIdPlugin}*}
{*                        {if $pubIdPlugin->getPubIdType() != 'doi'}*}
{*                            {continue}*}
{*                        {/if}*}
{*                        {if $issue->getPublished()}*}
{*                            {assign var=pubId value=$article->getStoredPubId($pubIdPlugin->getPubIdType())}*}
{*                        {else}*}
{*                            {assign var=pubId value=$pubIdPlugin->getPubId($article)} Preview pubId*}
{*                        {/if}*}
{*                        {if $pubId}*}
{*                            {assign var="doiUrl" value=$pubIdPlugin->getResolvingURL($currentJournal->getId(), $pubId)|escape}*}
{*                            <div class="doi">*}
{*                                <a href="{$doiUrl}">*}
{*                                    {$doiUrl}*}
{*                                </a>*}
{*                            </div>*}
{*                        {/if}*}
{*                    {/foreach}*}
{*                {/if}*}

                {if !$hideGalleys && $article->getGalleys()}
                    <div class="btn-group" role="group">
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
