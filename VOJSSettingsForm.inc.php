<?php

import('lib.pkp.classes.form.Form');

class VOJSSettingsForm extends Form {

    /** @var int */
    var $_journalId;

    /** @var object */
    var $_plugin;

    /**
     * Constructor
     * @param $plugin GoogleAnalyticsPlugin
     * @param $journalId int
     */
    function __construct($plugin, $journalId) {
        $this->_journalId = $journalId;
        $this->_plugin = $plugin;

        parent::__construct($plugin->getTemplateResource('setting/settingsForm.tpl'));

        $this->addCheck(new FormValidator($this, 'googleAnalyticsSiteId', 'required', 'plugins.generic.googleAnalytics.manager.settings.googleAnalyticsSiteIdRequired'));

        $this->addCheck(new FormValidatorPost($this));
        $this->addCheck(new FormValidatorCSRF($this));
    }

    /**
     * Initialize form data.
     */
    function initData() {
        $this->_data = array(
            'googleAnalyticsSiteId' => $this->_plugin->getSetting($this->_journalId, 'googleAnalyticsSiteId'),
        );
    }

    /**
     * Assign form data to user-submitted data.
     */
    function readInputData() {
        $this->readUserVars(array('googleAnalyticsSiteId'));
    }

    /**
     * @copydoc Form::fetch()
     */
    function fetch($request, $template = null, $display = false) {
        $templateMgr = TemplateManager::getManager($request);
        $templateMgr->assign('pluginName', $this->_plugin->getName());
        return parent::fetch($request, $template, $display);
    }

    /**
     * @copydoc Form::execute()
     */
    function execute(...$functionArgs) {
        $this->_plugin->updateSetting($this->_journalId, 'googleAnalyticsSiteId', trim($this->getData('googleAnalyticsSiteId'), "\"\';"), 'string');
        parent::execute(...$functionArgs);
    }
}