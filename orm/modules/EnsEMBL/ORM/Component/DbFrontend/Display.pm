package EnsEMBL::ORM::Component::DbFrontend::Display;

### NAME: EnsEMBL::ORM::Component::DbFrontend::Display
### Creates a page displaying one or more records in full 

### STATUS: Under development
### Note: This module should not be modified! 
### To customise an individual record display, see (or create) the appropriate 
### EnsEMBL::ORM::DbFrontend module in your plugin

### DESCRIPTION:

use strict;
use warnings;
no warnings "uninitialized";

use base qw(EnsEMBL::ORM::Component::DbFrontend);

sub _init {
  my $self = shift;
  $self->cacheable( 0 );
  $self->ajaxable(  0 );
}

sub content {
  my $self = shift;
  my $hub = $self->hub;
  my $html;
  my (@records, $count);
  my $config = $self->get_frontend_config;

  if ($hub->param('id')) {
    my @ids = ($hub->param('id'));
    @records = @{$self->object->fetch_by_id(\@ids)};
  }
  else {
    if ($config->pagination) {
      @records = @{$self->object->fetch_by_page($config->pagination)};
      $count = $self->object->count;
      $html .= $self->create_pagination($config->pagination, $count);
    }
    else {
      @records = @{$self->object->fetch_all};
    }
  }

  if (@records) {
    my @column_names;
    if ($config) {
      @column_names = @{$config->show_fields}; 
    }
    unless (@column_names) {
      my @columns = @{$self->object->get_table_columns};
      push @columns, @{$self->object->get_related_columns};
      foreach my $column (@columns) {
        push @column_names, $column->name;
      }
    }

    $html .= '<p>Total records: '.@records.'</p>';
    foreach my $record (@records) {
      $html .= "<hr />\n\n";
      $html .= '<table style="width:100%">';
      foreach my $name (@column_names) {
        my $value = $record->$name;
        if (ref($value) eq 'ARRAY') {
          $value = '(Multiple values)';
        }
        $html .= '<tr><th style="width:25%">'.ucfirst($name)
                  .'</th><td style="width:75%">'.$value.'</td></tr>',
      }
      $html .= "</table>\n\n";
    }
  }

  if ($config->pagination) {
    $html .= $self->create_pagination($config->pagination, $count);
  }

  return $html;
}

1;
