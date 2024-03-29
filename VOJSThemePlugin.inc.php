<?php

/**
 * @file plugins/themes/default/BootstrapThreeThemePlugin.inc.php
 *
 * Copyright (c) 2014-2017 Simon Fraser University Library
 * Copyright (c) 2003-2017 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @class BootstrapThreeThemePlugin
 * @ingroup plugins_themes_bootstrap3
 *
 * @brief Default theme
 */

import('lib.pkp.classes.plugins.ThemePlugin');

class VOJSThemePlugin extends ThemePlugin
{
    /**
     * Initialize the theme
     *
     * @return null
     */
    public function init()
    {

        // Register option for bootstrap themes
//		$this->addOption('bootstrapTheme', 'FieldOptions', [
//			'type' => 'radio',
//			'label' => __('plugins.themes.vojs.options.bootstrapTheme.label'),
//			'description' => __('plugins.themes.vojs.options.bootstrapTheme.description'),
//			'options' => [
//				[
//					'value' => 'bootstrap3',
//					'label' => __('plugins.themes.vojs.options.bootstrapTheme.bootstrap3'),
//				],
//				[
//					'value' => 'cerulean',
//					'label' => __('plugins.themes.vojs.options.bootstrapTheme.cerulean'),
//				],
//				[
//					'value' => 'cleanblog',
//					'label' => __('plugins.themes.vojs.options.bootstrapTheme.cleanblog'),
//				],
//				[
//					'value' => 'cosmo',
//					'label' => __('plugins.themes.vojs.options.bootstrapTheme.cosmo'),
//				],
//				[
//					'value' => 'cyborg',
//					'label' => __('plugins.themes.vojs.options.bootstrapTheme.cyborg'),
//				],
//				[
//					'value' => 'darkly',
//					'label' => __('plugins.themes.vojs.options.bootstrapTheme.darkly'),
//				],
//				[
//					'value' => 'flatly',
//					'label' => __('plugins.themes.vojs.options.bootstrapTheme.flatly'),
//				],
//				[
//					'value' => 'journal',
//					'label' => __('plugins.themes.vojs.options.bootstrapTheme.journal'),
//				],
//				[
//					'value' => 'lumen',
//					'label' => __('plugins.themes.vojs.options.bootstrapTheme.lumen'),
//				],
//				[
//					'value' => 'paper',
//					'label' => __('plugins.themes.vojs.options.bootstrapTheme.paper'),
//				],
//				[
//					'value' => 'readable',
//					'label' => __('plugins.themes.vojs.options.bootstrapTheme.readable'),
//				],
//				[
//					'value' => 'sandstone',
//					'label' => __('plugins.themes.vojs.options.bootstrapTheme.sandstone'),
//				],
//				[
//					'value' => 'simplex',
//					'label' => __('plugins.themes.vojs.options.bootstrapTheme.simplex'),
//				],
//				[
//					'value' => 'slate',
//					'label' => __('plugins.themes.vojs.options.bootstrapTheme.slate'),
//				],
//				[
//					'value' => 'spacelab',
//					'label' => __('plugins.themes.vojs.options.bootstrapTheme.spacelab'),
//				],
//				[
//					'value' => 'superhero',
//					'label' => __('plugins.themes.vojs.options.bootstrapTheme.superhero'),
//				],
//				[
//					'value' => 'united',
//					'label' => __('plugins.themes.vojs.options.bootstrapTheme.united'),
//				],
//				[
//					'value' => 'yeti',
//					'label' => __('plugins.themes.vojs.options.bootstrapTheme.yeti'),
//				],
//			],
//		]);

        // Determine the path to the glyphicons font in Bootstrap
//        $iconFontPath = Application::get()->getRequest()->getBaseUrl() . '/' . $this->getPluginPath() . '/bootstrap/fonts/';

        $this->addStyle('bootstrap', 'styles/bootstrap.less');
//        $this->modifyStyle('bootstrap', ['addLessVariables' => '@icon-font-path:"' . $iconFontPath . '";']);
        $this->addStyle('fa', Application::get()->getRequest()->getBaseUrl() . '/lib/vojs/styles/fontawesome/css/all.min.css', array('baseUrl' => ''));


        $locale = AppLocale::getLocale();
        if (AppLocale::getLocaleDirection($locale) === 'rtl') {
            if (Config::getVar('general', 'enable_cdn')) {
                $this->addStyle('bootstrap-rtl', '//cdn.rawgit.com/morteza/bootstrap-rtl/v3.3.4/dist/css/bootstrap-rtl.min.css', array('baseUrl' => ''));
            } else {
                $this->addStyle('bootstrap-rtl', 'styles/bootstrap-rtl.min.css');
            }
        }

        // Load jQuery from a CDN or, if CDNs are disabled, from a local copy.
        $min = Config::getVar('general', 'enable_minified') ? '.min' : '';
        $request = Application::get()->getRequest();
        if (Config::getVar('general', 'enable_cdn')) {
            $jquery = '//ajax.googleapis.com/ajax/libs/jquery/' . CDN_JQUERY_VERSION . '/jquery' . $min . '.js';
            $jqueryUI = '//ajax.googleapis.com/ajax/libs/jqueryui/' . CDN_JQUERY_UI_VERSION . '/jquery-ui' . $min . '.js';
        } else {
            // Use OJS's built-in jQuery files
            $jquery = $request->getBaseUrl() . '/lib/pkp/lib/vendor/components/jquery/jquery' . $min . '.js';
            $jqueryUI = $request->getBaseUrl() . '/lib/pkp/lib/vendor/components/jqueryui/jquery-ui' . $min . '.js';
        }
        // Use an empty `baseUrl` argument to prevent the theme from looking for
        // the files within the theme directory
        $this->addScript('jQuery', $jquery, array('baseUrl' => ''));
        $this->addScript('jQueryUI', $jqueryUI, array('baseUrl' => ''));
        $this->addScript('jQueryTagIt', $request->getBaseUrl() . '/lib/pkp/js/lib/jquery/plugins/jquery.tag-it.js', array('baseUrl' => ''));

        // Load Bootstrap
        $this->addScript('bootstrap', 'bootstrap/js/bootstrap.min.js');

        // Add navigation menu areas for this theme
        $this->addMenuArea(array('primary', 'user'));

        HookRegistry::register('TemplateManager::display', array($this, 'loadTemplateData'));
    }

    /**
     * Load custom data for templates
     */
    public function loadTemplateData($hookName, $args)
    {
        $request = Application::getRequest();
        $journal = $request->getJournal();

        $templateMgr = $args[0];

        $templateMgr->assign('journal', $journal);
        $templateMgr->assign('isPostRequest', $request->isPost());
        if (!defined('SESSION_DISABLE_INIT')) {
            $journal = $request->getJournal();
            if (isset($journal)) {
                $locales = $journal->getSupportedLocaleNames();

            } else {
                $site = $request->getSite();
                $locales = $site->getSupportedLocaleNames();
            }
        } else {
            $locales = AppLocale::getAllLocales();
            $templateMgr->assign('languageToggleNoUser', true);
        }

        if (isset($locales) && count($locales) > 1) {
            $templateMgr->assign('enableLanguageToggle', true);
            $templateMgr->assign('languageToggleLocales', $locales);
        }

        $templateMgr->assign('organizationName', $journal->getLocalizedData('additionalHomeContent'));
        include "autoload.php";
        $templateMgr->assign('noTopBar',envVojs('NO_TOP_BAR'));
        $templateMgr->assign('enableVojsLangBlock',envVojs('VOJS_LANG_BLOCK'));
    }

    /**
     * Get the display name of this plugin
     * @return string
     */
    function getDisplayName()
    {
        return __('plugins.themes.vojs.name');
    }

    /**
     * Get the description of this plugin
     * @return string
     */
    function getDescription()
    {
        return __('plugins.themes.vojs.description');
    }
}
