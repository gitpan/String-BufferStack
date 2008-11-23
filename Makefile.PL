use inc::Module::Install;

name ('String-BufferStack');
author ('Alex Vandiver <alexmv@bestpractical.com>');
version_from ('lib/String/BufferStack.pm');
abstract_from('lib/String/BufferStack.pm');
license('Artistic');

requires( perl => '5.8.0');

&WriteAll;
