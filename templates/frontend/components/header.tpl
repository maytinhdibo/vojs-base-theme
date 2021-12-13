{**
 * lib/pkp/templates/frontend/components/header.tpl
 *
 * Copyright (c) 2014-2017 Simon Fraser University Library
 * Copyright (c) 2003-2017 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @brief Common frontend site header.
 *
 * @uses $isFullWidth bool Should this page be displayed without sidebars? This
 *       represents a page-level override, and doesn't indicate whether or not
 *       sidebars have been configured for thesite.
 *}

{* Determine whether a logo or title string is being displayed *}
{assign var="showingLogo" value=true}
{if $displayPageHeaderTitle && !$displayPageHeaderLogo && is_string($displayPageHeaderTitle)}
    {assign var="showingLogo" value=false}
{/if}

<!DOCTYPE html>
<html lang="{$currentLocale|replace:"_":"-"}" xml:lang="{$currentLocale|replace:"_":"-"}">
{if !$pageTitleTranslated}{capture assign="pageTitleTranslated"}{translate key=$pageTitle}{/capture}{/if}
{include file="frontend/components/headerHead.tpl"}
<body class="pkp_page_{$requestedPage|escape|default:"index"} pkp_op_{$requestedOp|escape|default:"index"}{if $showingLogo} has_site_logo{/if}">
<div class="pkp_structure_page">
    <nav id="accessibility-nav" class="sr-only" role="navigation"
         aria-label="{translate|escape key="plugins.themes.vojs.accessible_menu.label"}">
        <ul>
            <li>
                <a href="#main-navigation">{translate|escape key="plugins.themes.vojs.accessible_menu.main_navigation"}</a>
            </li>
            <li>
                <a href="#main-content">{translate|escape key="plugins.themes.vojs.accessible_menu.main_content"}</a>
            </li>
            <li><a href="#sidebar">{translate|escape key="plugins.themes.vojs.accessible_menu.sidebar"}</a></li>
        </ul>
    </nav>

    {* Header *}
    <header class="navbar navbar-default" id="headerNavigationContainer" role="banner">
        {if !$noTopBar}
            <div id="header-bar" class="hidden-xs">
                <div class="header-bar hidden-xs">
                    <div class="container">
                        <span class="top-additional-content">{$organizationName|upper}</span>
                        <div class="language_toggle">
                            {foreach from=$languageToggleLocales item=localeName key=localeKey name=langLoop}
                                <a href="{url router=$smarty.const.ROUTE_PAGE page="user" op="setLocale" path=$localeKey source=$smarty.server.REQUEST_URI}">
                                    {$localeName}
                                </a>
                                {if not $smarty.foreach.langLoop.last}
                                    |
                                {/if}
                            {/foreach}
                        </div>
                    </div>
                </div>
            </div>
        {/if}

        <div class="logo hidden-xs">
            <div class="container">
                <a href="{url router=$smarty.const.ROUTE_PAGE page="index"}">
                    <img src="{$publicFilesDir}/{$displayPageHeaderLogo.uploadName|escape:"url"}"
                         {if $displayPageHeaderLogo.altText != ''}alt="{$displayPageHeaderLogo.altText|escape}"{/if}>
                </a>
            </div>
        </div>

        <div class="navbar-header navbar-dark bg-dark" style="position: relative">
            <span class="top-additional-content visible-xs top-additional-content-mobile">{$organizationName|upper}</span>
            {* Mobile hamburger menu *}
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#nav-menu"
                    aria-expanded="false" aria-controls="nav-menu">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>

            {* Logo or site title. Only use <h1> heading on the homepage.
               Otherwise that should go to the page title. *}
        </div>


        {* Primary site navigation *}
        {capture assign="primaryMenu"}
            {load_menu name="primary" id="main-navigation" ulClass="nav navbar-nav"}
        {/capture}

        {if !empty(trim($primaryMenu)) || $currentContext}
            <nav id="nav-menu" class="navbar-collapse collapse"
                 aria-label="{translate|escape key="common.navigation.site"}">
                <div class="container">
                    {* Primary navigation menu for current application *}
                    {$primaryMenu}

                    {*<nav aria-label="{translate|escape key="common.navigation.user"}">*}
                    {load_menu name="user" id="navigationUser" ulClass="nav nav-pills tab-list pull-right"}
                    {*</nav>*}

                    {* Search form *}
                    {if $currentContext}
                        <div class="pull-md-right">
                            {include file="frontend/components/searchForm_simple.tpl"}
                        </div>
                    {/if}

                    {* Language list mobile*}
                    <div class="nav navbar-nav visible-xs">
                        {foreach from=$languageToggleLocales item=localeName key=localeKey name=langLoop}
                            <li>
                                <a href="{url router=$smarty.const.ROUTE_PAGE page="user" op="setLocale" path=$localeKey source=$smarty.server.REQUEST_URI}">
                                    {$localeName}
                                </a>
                            </li>
                        {/foreach}
                    </div>
                </div>
            </nav>
        {/if}

        {assign var="thumb" value=$journal->getLocalizedData('journalThumbnail')}

        {if $thumb}
            <a class="logo-mobile visible-xs" href="{url router=$smarty.const.ROUTE_PAGE page="index"}">
                <img src="{$publicFilesDir}/{$thumb.uploadName|escape:"url"}"{if $thumb.altText}
                alt="{$thumb.altText|escape|default:''}"{/if} />
            </a>
        {/if}

</div><!-- .pkp_head_wrapper -->
</header><!-- .pkp_structure_head -->

{* Wrapper for page content and sidebars *}
<div class="pkp_structure_content container">
    <main class="pkp_structure_main" role="main">
