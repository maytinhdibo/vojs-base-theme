{**
 * templates/frontend/objects/article_details.tpl
 *
 * Copyright (c) 2014-2017 Simon Fraser University Library
 * Copyright (c) 2003-2017 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @brief View of an Article which displays all details about the article.
 *  Expected to be primary object on the page.
 *
 * @uses $article Article This article
 * @uses $issue Issue The issue this article is assigned to
 * @uses $section Section The journal section this article is assigned to
 * @uses $keywords array List of keywords assigned to this article
 * @uses $citationFactory @todo
 * @uses $pubIdPlugins @todo
 *}
<div class="article-details">

    <div class="row">

        <section class="article-sidebar col-md-4">

            {* Screen-reader heading for easier navigation jumps *}
            <h2 class="sr-only">{translate key="plugins.themes.vojs.article.sidebar"}</h2>

            {*			 Article/Issue cover image *}
            {*			{if $article->getLocalizedCoverImage() || $issue->getLocalizedCoverImage()}*}
            {*				<div class="cover-image">*}
            {*					{if $article->getLocalizedCoverImage()}*}
            {*						<img class="img-responsive" src="{$article->getLocalizedCoverImageUrl()|escape}"{if $article->getLocalizedCoverImageAltText()} alt="{$article->getLocalizedCoverImageAltText()|escape}"{/if}>*}
            {*					{else}*}
            {*						<a href="{url page="issue" op="view" path=$issue->getBestIssueId()}">*}
            {*							<img class="img-responsive" src="{$issue->getLocalizedCoverImageUrl()|escape}"{if $issue->getLocalizedCoverImageAltText()} alt="{$issue->getLocalizedCoverImageAltText()|escape}"{/if}>*}
            {*						</a>*}
            {*					{/if}*}
            {*				</div>*}
            {*			{/if}*}

            {* Article Galleys *}
            {if $primaryGalleys || $supplementaryGalleys}
                <div class="download">
                    {if $primaryGalleys}
                        {foreach from=$primaryGalleys item=galley}
                            {include file="frontend/objects/galley_link.tpl" parent=$article purchaseFee=$currentJournal->getSetting('purchaseArticleFee') purchaseCurrency=$currentJournal->getSetting('currency')}
                        {/foreach}
                    {/if}
                    {if $supplementaryGalleys}
                        {foreach from=$supplementaryGalleys item=galley}
                            {include file="frontend/objects/galley_link.tpl" parent=$article isSupplementary="1"}
                        {/foreach}
                    {/if}
                </div>
            {/if}

            <div class="list-group">

                {* Published date *}
                {if $article->getDatePublished()}
                    <div class="list-group-item date-published">
                        {capture assign=translatedDatePublished}{translate key="submissions.published"}{/capture}
                        <strong>{translate key="semicolon" label=$translatedDatePublished}</strong>
                        {$article->getDatePublished()|date_format:$dateFormatShort}
                    </div>
                {/if}

                {* Views *}
                <div class="list-group-item views">
                    <strong>{translate key="article.abstractViewsNumber"}</strong>: {$article->getViews()}<br/>
                    {assign var=galleys value=$article->getGalleys()}
                    {if $galleys}
                        {foreach from=$galleys item=galley name=galleyList}
                            <strong>{translate key="article.eachGalleyViewsNumber"} {$galley->getGalleyLabel()}</strong>: {$galley->getViews()}<br/>
                        {/foreach}
                    {/if}
                </div>

                {* DOI (requires plugin) *}
                {foreach from=$pubIdPlugins item=pubIdPlugin}
                    {if $pubIdPlugin->getPubIdType() != 'doi'}
                        {continue}
                    {/if}
                    {if $issue->getPublished()}
                        {assign var=pubId value=$article->getStoredPubId($pubIdPlugin->getPubIdType())}
                    {else}
                        {assign var=pubId value=$pubIdPlugin->getPubId($article)}{* Preview pubId *}
                    {/if}
                    {if $pubId}
                        {assign var="doiUrl" value=$pubIdPlugin->getResolvingURL($currentJournal->getId(), $pubId)|escape}
                        <div class="list-group-item doi">
                            {capture assign=translatedDoi}{translate key="plugins.pubIds.doi.readerDisplayName"}{/capture}
                            <strong>{translate key="semicolon" label=$translatedDoi}</strong>
                            <a href="{$doiUrl}">
                                {$doiUrl}
                            </a>
                        </div>
                    {/if}
                {/foreach}
            </div>
            
            

            {* Issue article appears in *}
            <div class="panel panel-default issue">
                <div class="panel-heading">
                    {translate key="issue.issue"}
                </div>
                <div class="panel-body">
                    <a class="title"
                       href="{url|escape page="issue" op="view" path=$issue->getBestIssueId($currentJournal)}">
                        {$issue->getIssueIdentification()|escape}
                    </a>

                </div>
            </div>

            {if $section}
                <div class="panel panel-default section">
                    <div class="panel-heading">
                        {translate key="section.section"}
                    </div>
                    <div class="panel-body">
                        {$section->getLocalizedTitle()|escape}
                    </div>
                </div>
            {/if}

            {* How to cite *}
            {if $citation}
                <div class="panel panel-default how-to-cite">
                    <div class="panel-heading">
                        {translate key="submission.howToCite"}
                    </div>
                    <div class="panel-body">
                        <div id="citationOutput" role="region" aria-live="polite">
                            {$citation}
                        </div>
                        <div class="btn-group">
                            <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown"
                                    aria-controls="cslCitationFormats">
                                {translate key="submission.howToCite.citationFormats"}
                                <span class="caret"></span>
                            </button>
                            <ul class="dropdown-menu" role="menu">
                                {foreach from=$citationStyles item="citationStyle"}
                                    <li>
                                        <a
                                                aria-controls="citationOutput"
                                                href="{url page="citationstylelanguage" op="get" path=$citationStyle.id params=$citationArgs}"
                                                data-load-citation
                                                data-json-href="{url page="citationstylelanguage" op="get" path=$citationStyle.id params=$citationArgsJson}"
                                        >
                                            {$citationStyle.title|escape}
                                        </a>
                                    </li>
                                {/foreach}
                                {* Download citation formats *}
                                {if count($citationDownloads)}
                                    <div class="panel-heading">{translate key="submission.howToCite.downloadCitation"}</div>

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
                    </div>
                </div>
            {/if}

            {* PubIds (requires plugins) *}
            {foreach from=$pubIdPlugins item=pubIdPlugin}
                {if $pubIdPlugin->getPubIdType() == 'doi'}
                    {continue}
                {/if}
                {if $issue->getPublished()}
                    {assign var=pubId value=$article->getStoredPubId($pubIdPlugin->getPubIdType())}
                {else}
                    {assign var=pubId value=$pubIdPlugin->getPubId($article)}{* Preview pubId *}
                {/if}
                {if $pubId}
                    <div class="panel panel-default pub_ids">
                        <div class="panel-heading">
                            {$pubIdPlugin->getPubIdDisplayType()|escape}
                        </div>
                        <div class="panel-body">
                            {if $pubIdPlugin->getResolvingURL($currentJournal->getId(), $pubId)|escape}
                                <a id="pub-id::{$pubIdPlugin->getPubIdType()|escape}"
                                   href="{$pubIdPlugin->getResolvingURL($currentJournal->getId(), $pubId)|escape}">
                                    {$pubIdPlugin->getResolvingURL($currentJournal->getId(), $pubId)|escape}
                                </a>
                            {else}
                                {$pubId|escape}
                            {/if}
                        </div>
                    </div>
                {/if}
            {/foreach}

        </section><!-- .article-sidebar -->

        <div class="col-md-8 article-details">
            <header style="margin-bottom: 1em">
                <h2>
                    {$article->getLocalizedTitle()|escape}
                    {if $article->getLocalizedSubtitle()}
                        <small class="sub-title">
                            {$article->getLocalizedSubtitle()|escape}
                        </small>
                    {/if}
                </h2>
                <div id="authorString">
                    <i style="color:#777">{{$article->getAuthorStringWithAffiliation()}}</i>
                </div>
            </header>
            <section class="article-main">

                {* Screen-reader heading for easier navigation jumps *}
                <h2 class="sr-only">{translate key="plugins.themes.vojs.article.main"}</h2>

                {* Article abstract *}
                {if $article->getLocalizedAbstract()}
                    <div class="article-summary" id="summary">
                        <h2>{translate key="article.abstract"}</h2>
                        <div class="article-abstract">
                            {$article->getLocalizedAbstract()|strip_unsafe_html|nl2br}
                        </div>
                    </div>
                {/if}

                {call_hook name="Templates::Article::Main"}

            </section><!-- .article-main -->

            <section class="article-more-details">

                {* Screen-reader heading for easier navigation jumps *}
                <h2 class="sr-only">{translate key="plugins.themes.vojs.article.details"}</h2>

                {* Article Subject *}
                {if $article->getLocalizedSubject()}
                    <div class="panel panel-default subject">
                        <div class="panel-heading">
                            {translate key="article.subject"}
                        </div>
                        <div class="panel-body">
                            {$article->getLocalizedSubject()|escape}
                        </div>
                    </div>
                {/if}

                {* Licensing info *}
                {if $copyright || $licenseUrl}
                    <div class="panel panel-default copyright">
                        <div class="panel-body">
                            {if $licenseUrl}
                                {if $ccLicenseBadge}
                                    {$ccLicenseBadge}
                                {else}
                                    <a href="{$licenseUrl|escape}" class="copyright">
                                        {if $copyrightHolder}
                                            {translate key="submission.copyrightStatement" copyrightHolder=$copyrightHolder copyrightYear=$copyrightYear}
                                        {else}
                                            {translate key="submission.license"}
                                        {/if}
                                    </a>
                                {/if}
                            {/if}
                            {$copyright}
                        </div>
                    </div>
                {/if}

                {* Author biographies *}
                {assign var="hasBiographies" value=0}
                {foreach from=$article->getAuthors() item=author}
                    {if $author->getLocalizedBiography()}
                        {assign var="hasBiographies" value=$hasBiographies+1}
                    {/if}
                {/foreach}
                {if $hasBiographies}
                    <div class="panel panel-default author-bios">
                        <div class="panel-heading">
                            {if $hasBiographies > 1}
                                {translate key="submission.authorBiographies"}
                            {else}
                                {translate key="submission.authorBiography"}
                            {/if}
                        </div>
                        <div class="panel-body">
                            {foreach from=$article->getAuthors() item=author}
                                {if $author->getLocalizedBiography()}
                                    <div class="media biography">
                                        <div class="media-body">
                                            <h3 class="media-heading biography-author">
                                                {if $author->getLocalizedAffiliation()}
                                                    {capture assign="authorName"}{$author->getFullName()|escape}{/capture}
                                                    {capture assign="authorAffiliation"}<span
                                                            class="affiliation">{implode(", ",$author->getLocalizedAffiliation())|escape}</span>{/capture}
                                                    {translate key="submission.authorWithAffiliation" name=$authorName affiliation=$authorAffiliation}
                                                {else}
                                                    {$author->getFullName()|escape}
                                                {/if}
                                            </h3>
                                            {$author->getLocalizedBiography()|strip_unsafe_html}
                                        </div>
                                    </div>
                                {/if}
                            {/foreach}
                        </div>
                    </div>
                {/if}

                {call_hook name="Templates::Article::Details"}

                {* Keywords *}
                {if !empty($publication->getLocalizedData('keywords'))}
                    <div class="article-keywords">
                        <h2>{translate key="article.subject"}</h2>
                        <p>
                            {foreach name="keywords" from=$publication->getLocalizedData('keywords') item="keyword"}
                                {$keyword|escape}{if !$smarty.foreach.keywords.last}{translate key="common.commaListSeparator"}{/if}
                            {/foreach}
                        </p>
                    </div>
                {/if}

                {* References *}
                {if $article->getCitations()}
                    <div class="article-references">
                        <h2>{translate key="submission.citations"}</h2>
                        <div class="article-references-content">
                            {* {$article->getCitations()|nl2br} *}
                        </div>
                    </div>

                    <style>
                        {literal}
                        .refIcon{
                            height: 1.1em;
                            vertical-align: middle;
                            margin: 0 0.2rem;
                        }
                        {/literal}
                    </style>
                  
                    <script>
                        var dataRef = `{$article->getCitations()}`;
                        var baseUrl = `{$baseUrl}`;
                    </script>


                    {literal}
                    
                        <script>
                            var refItems = dataRef.split("\n");
                            var refHTMLs = [];
                            for(var refItem of refItems){
                                //remove 1.
                                var rawRefItem = refItem.replace(/^\s*[0-9]+\.\s*/, '');
                                //remove [1]
                                rawRefItem = rawRefItem.replace(/^[\s*[0-9]+\]\s*/, '');

                                var DOI = false;
                                var doiParterns = ["https://doi.org/", "http://doi.org/","doi.org/", "doi: ", "doi:"]; 
                                for(var doiPartern of doiParterns){
                                    var pos = refItem.lastIndexOf(doiPartern);
                                    if(pos==-1){
                                    }else{
                                        var doiSub = refItem.substring(pos, refItem.length);
                                        if(doiPartern == "doi.org/") doiSub = "https://" + doiSub;
                                        doiSub = doiSub.replace(/doi: /g,'https://doi.org/');
                                        doiSub = doiSub.replace(/doi:/g,'https://doi.org/');

                                        DOI = doiSub.substring(0, doiSub.indexOf(" ") == -1 ? doiSub.length : doiSub.indexOf(" "));
                                        if(DOI[DOI.length - 1] == ".") DOI = DOI.substring(0, DOI.length - 1);
                                        break;
                                    }
                                }

                                refHTML = refItem 
                                + " <a target='_blank' title='Google Scholar' href='https://scholar.google.com/scholar?q=" + encodeURIComponent(rawRefItem) + "'>"
                                + "<img class='refIcon' src='" + baseUrl + "/templates/images/icons/gscholar.png'/>"+ "</a>"
                                + (DOI? " <a target='_blank' title='DOI' href='" + DOI +"'>"+"<img class='refIcon' src='"+baseUrl+"/templates/images/icons/doi.png'/>"+"</a>":"")
                                +" </br>";
                                refHTMLs.push(refHTML);
                            }

                            document.querySelector(".article-references-content").innerHTML = refHTMLs.join("");
                        </script>
                    {/literal}
                {/if}

            </section><!-- .article-details -->
        </div><!-- .col-md-8 -->
    </div><!-- .row -->

    </article>
</div>
