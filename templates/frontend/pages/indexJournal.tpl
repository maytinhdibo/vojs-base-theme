{**
 * templates/frontend/pages/indexJournal.tpl
 *
 * UPDATED/CHANGED/MODIFIED: Marc Behiels - marc@elemental.ca - 250416
 *
 * Copyright (c) 2014-2017 Simon Fraser University Library
 * Copyright (c) 2003-2017 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @brief Display the index page for a journal
 *
 * @uses $currentJournal Journal This journal
 * @uses $journalDescription string Journal description from HTML text editor
 * @uses $homepageImage object Image to be displayed on the homepage
 * @uses $additionalHomeContent string Arbitrary input from HTML text editor
 * @uses $announcements array List of announcements
 * @uses $numAnnouncementsHomepage int Number of announcements to display on the
 *       homepage
 * @uses $issue Issue Current issue
 *}
{include file="frontend/components/header.tpl" pageTitleTranslated=$currentJournal->getLocalizedName()}

<div id="main-content" class="page_index_journal col-md-9 main-content-index-page">

    {call_hook name="Templates::Index::journal"}

    <header class="page-header">
        <h2>{$currentJournal->getLocalizedName()}
        </h2>
    </header>

    {if $currentJournal->getLocalizedData('about')}
        <div class="journal-description">
            {$currentJournal->getLocalizedData('about')}
        </div>
    {/if}

    {* Announcements *}
    {if $numAnnouncementsHomepage && $announcements|count}
        <section class="cmp_announcements media">
            <header class="page-header">
                <h2>
                    {translate key="announcement.announcements"}
                </h2>
            </header>
            <div class="media-list">
                {foreach name=announcements from=$announcements item=announcement}
                    {if $smarty.foreach.announcements.iteration > $numAnnouncementsHomepage}
                        {break}
                    {/if}
                    {include file="frontend/objects/announcement_summary.tpl" heading="h3"}
                {/foreach}
            </div>
        </section>
    {/if}


    {* Latest issue *}
    {if $issue}
        <section class="current_issue">
            <header class="page-header">
                <h2>
                    {translate key="journal.currentIssue"}
                </h2>
            </header>
            <p class="current_issue_title lead">
                {$issue->getIssueIdentification()|strip_unsafe_html}
            </p>
            {include file="frontend/objects/issue_toc.tpl"}
            <a href="{url router=$smarty.const.ROUTE_PAGE page="issue" op="archive"}" class="btn btn-primary read-more">
                {translate key="journal.viewAllIssues"}
                <i class="fas fa-angle-right"></i>
            </a>
        </section>
    {/if}

    {*    *}{* Additional Homepage Content *}
    {*    {if $additionalHomeContent}*}
    {*        <section class="additional_content">*}
    {*            {$additionalHomeContent}*}
    {*        </section>*}
    {*    {/if}*}
</div><!-- .page -->

<div class="sidebar col-md-3">
    {*    side bar start*}

    {*    {if $homepageImage}*}
    {*        <div class="homepage-image thumb-journal hidden-xs hidden-sm">*}
    {*            <img class="img-responsive" src="{$publicFilesDir}/{$homepageImage.uploadName|escape:"url"}"*}
    {*                 alt="{$homepageImageAltText|escape}">*}
    {*        </div>*}
    {*    {/if}*}
    {if $enableVojsLangBlock}
        <div class="pkp_block block_language">
            <h2 class="title">
                {translate key="common.language"}
            </h2>

            <div class="content">
                {foreach from=$languageToggleLocales item=localeName key=localeKey name=local}
                    <span class="locale_{$localeKey|escape}{if $localeKey == $currentLocale} current{/if}" lang="{$localeKey|replace:"_":"-"}">
                        <a href="{url router=$smarty.const.ROUTE_PAGE page="user" op="setLocale" path=$localeKey source=$smarty.server.REQUEST_URI}">{$localeName}</a>
                    </span>
                    {if !$smarty.foreach.local.last}|{/if}
                {/foreach}
            </div>
        </div><!-- .block_language -->
    {/if}

    {* Sidebars *}
    {if empty($isFullWidth)}
        {capture assign="sidebarCode"}{call_hook name="Templates::Common::Sidebar"}{/capture}
        {if $sidebarCode}
            <aside id="sidebar" class="pkp_structure_sidebar left" role="complementary"
                   aria-label="{translate|escape key="common.navigation.sidebar"}">
                {$sidebarCode}
            </aside>
            <!-- pkp_sidebar.left -->
        {/if}
    {/if}

</div>
{*Side bar*}

</main>


{include file="frontend/components/footer.tpl"}
