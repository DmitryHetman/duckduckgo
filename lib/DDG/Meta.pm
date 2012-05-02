package DDG::Meta;

use strict;
use warnings;
use Carp;

use DDG::Meta::RequestHandler;
use DDG::Meta::ZeroClickInfo;
use DDG::Meta::ZeroClickInfoSpice;
use DDG::Meta::ShareDir;
use DDG::Meta::Block;
require Moo::Role;

require Moo;
require Data::Printer;
require utf8::all;

sub apply_base_to_package {
	my ( $class, $target ) = @_;

	my $sub = eval qq{
		package $target;
		sub {
			Moo->import;
			Data::Printer->import;
			utf8::all->import;
		}
	};
	$sub->();

}

sub apply_goodie_keywords {
	my ( $class, $target ) = @_;
	DDG::Meta::ZeroClickInfo->apply_keywords($target);
	DDG::Meta::ShareDir->apply_keywords($target);
	DDG::Meta::Block->apply_keywords($target);
	DDG::Meta::RequestHandler->apply_keywords($target,sub {
		shift->zci_new(
			scalar @_ == 1 && ref $_[0] eq 'HASH' ? $_[0] :
				@_ % 2 ? ( answer => @_ ) : @_
		);
	},'DDG::IsGoodie');
}

sub apply_spice_keywords {
	my ( $class, $target ) = @_;
	DDG::Meta::ZeroClickInfoSpice->apply_keywords($target);
	DDG::Meta::ShareDir->apply_keywords($target);
	DDG::Meta::Block->apply_keywords($target);
	DDG::Meta::RequestHandler->apply_keywords($target,sub {
		shift->spice_new(@_);
	},'DDG::IsSpice');
}

1;