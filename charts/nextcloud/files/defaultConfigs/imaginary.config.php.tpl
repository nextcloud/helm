<?php
$CONFIG = array (
  'preview_imaginary_url' => 'http://{{ template "nextcloud.fullname" . }}-imaginary',
  'enable_previews' => true,
  'enabledPreviewProviders' => array (
    'OC\Preview\Imaginary',
    'OC\Preview\ImaginaryPDF',
    /*
      defaults:
      https://docs.nextcloud.com/server/latest/admin_manual/configuration_server/config_sample_php_parameters.html#enabledpreviewproviders
    */
    'OC\Preview\BMP',
    // 'OC\Preview\GIF',
    // 'OC\Preview\JPEG',
    'OC\Preview\Krita',
    'OC\Preview\MarkDown',
    'OC\Preview\MP3',
    'OC\Preview\OpenDocument',
    // 'OC\Preview\PNG',
    'OC\Preview\TXT',
    'OC\Preview\XBitmap',
  ),
);
