=head1 LICENSE

Copyright [1999-2015] Wellcome Trust Sanger Institute and the EMBL-European Bioinformatics Institute

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

=cut

package EnsEMBL::Web::Factory::Search;

use strict;

use base qw(EnsEMBL::Web::Factory);
use EnsEMBL::Web::Cache;

sub createObjects {
    my $self = shift;

    # Create object here
    my $endpoint = $self->species_defs->ENSEMBL_SOLR_ENDPOINT;
    my $solr = {
      endpoint => $endpoint
    };

    my $object = $self->new_object('Search', $solr, $self->__data);
    $self->DataObjects($object);
}

1;
