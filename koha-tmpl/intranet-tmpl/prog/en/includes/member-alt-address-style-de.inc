        <fieldset class="rows" id="memberentry_address">
        <legend id="alt_address_lgd">Alternate address</legend><ol>

        [% IF roadtypes %]
                <li>
            [% IF ( mandatoryB_streettype ) %]
                <label for="B_streettype" class="required">
            [% ELSE %]
                <label for="B_streettype">
        [% END %]
            Street type: </label>
            <select name="B_streettype">
            <option value=""></option>
            [% FOR roadtype IN roadtypes %]
                [% IF roadtype.authorised_value == patron.B_streettype %]
                    <option value="[% roadtype.authorised_value | html %]" selected="selected">[% roadtype.lib | html %]</option>
                [% ELSE %]
                    <option value="[% roadtype.authorised_value | html %]">[% roadtype.lib | html %]</option>
                [% END %]
            [% END %]
            </select>
            [% IF ( mandatoryB_streettype ) %]<span class="required">Required</span>[% END %]
            </li>
        [% END %]

        [% UNLESS noB_address %]
            <li>
                [% IF ( mandatoryB_address ) %]
                    <label for="B_address" class="required">
                [% ELSE %]
                    <label for="B_address">
                [% END %]
                Address: </label>
                    <input type="text" id="B_address" name="B_address" size="40" value="[% patron.B_address | html %]" />
      [% IF ( mandatoryB_address ) %]<span class="required">Required</span>[% END %]
            </li>
        [% END %]

        [% UNLESS noB_streetnumber %]
            <li>
                [% IF ( mandatoryB_streetnumber ) %]
                    <label for="B_streetnumber" class="required">
                [% ELSE %]
                    <label for="B_streetnumber">
                [% END %]
                Street Number: </label>
                    <input type="text" id="B_streetnumber" name="B_streetnumber" size="5" value="[% patron.B_streetnumber | html %]" />
                [% IF ( mandatoryB_streetnumber ) %]<span class="required">Required</span>[% END %]
            </li>
        [% END %]

        [% UNLESS noB_address2 %]
            <li>
                [% IF ( mandatoryB_address2 ) %]
                    <label for="B_address2" class="required">
                [% ELSE %]
                    <label for="B_address2">
                [% END %]
                Address 2: </label>
                    <input type="text" id="B_address2" name="B_address2" size="40" value="[% patron.B_address2 | html %]" />
      [% IF ( mandatoryB_address2 ) %]<span class="required">Required</span>[% END %]
            </li>
        [% END %]
        [% UNLESS noB_zipcode %]
                        <li>
                                [% IF ( mandatoryB_zipcode ) %]
                                        <label for="B_zipcode" class="required">
                                [% ELSE %]
                                        <label for="B_zipcode">
                                [% END %]
                                ZIP/Postal code: </label>
                    <input type="text" id="B_zipcode" name="B_zipcode" maxlength="10" size="10" value="[% patron.B_zipcode | html %]" />
          [% IF ( mandatoryB_zipcode ) %]<span class="required">Required</span>[% END %]
                        </li>
        [% END %]
        [% UNLESS noB_city %]
            <li>
                [% IF ( mandatoryB_city ) %]
                    <label for="B_city" class="required" >
                [% ELSE %]
                    <label for="B_city">
                [% END %]
                City: </label>
                <input type="text" id="B_city" name="B_city" size="20" value="[% patron.B_city | html %]" />
                [% IF cities.count %]or choose
                    <select class="select_city" data-addressfield="B_" name="select_city">
                        <option value="|||"></option>
                        [% FOREACH c IN cities %]
                            [% IF c.city_name == patron.B_city && c.city_state == patron.B_state && c.city_zipcode == patron.B_zipcode %]
                            <option value="[% c.city_zipcode | html %]|[% c.city_name | html %]|[% c.city_state | html %]|[% c.city_country | html %]" selected="selected">
                            [% ELSE %]
                            <option value="[% c.city_zipcode | html %]|[% c.city_name | html %]|[% c.city_state | html %]|[% c.city_country | html %]">
                            [% END %]
                                [% c.city_name | html %] [% c.city_state | html %] [% c.city_zipcode | html %]
                            </option>
                        [% END %]
                    </select>
                [% END %]
      [% IF ( mandatoryB_city ) %]<span class="required">Required</span>[% END %]
            </li>
        [% END %]
        [% UNLESS noB_state %]
            <li>
                [% IF ( mandatoryB_state ) %]
                    <label for="B_state" class="required" >
                [% ELSE %]
                    <label for="B_state">
                [% END %]
                State: </label>
                <input type="text" id="B_state" name="B_state" size="20" value="[% patron.B_state | html %]" />
      [% IF ( mandatoryB_state ) %]<span class="required">Required</span>[% END %]
            </li>
        [% END %]
        [% UNLESS noB_country %]
            <li>
                [% IF ( mandatoryB_country ) %]
                    <label for="B_country" class="required">
                [% ELSE %]
                    <label for="B_country">
                [% END %]
                Country: </label>
                    <input type="text" id="B_country" name="B_country" size="20" value="[% patron.B_country | html %]" />
      [% IF ( mandatoryB_country ) %]<span class="required">Required</span>[% END %]
            </li>
        [% END %]
        [% UNLESS noB_phone %]
            <li>
                [% IF ( mandatoryB_phone ) %]
                <label for="B_phone" class="required">
                [% ELSE %]
                <label for="B_phone">
                [% END %]
                Phone: </label>
                    <input type="text" id="B_phone" name="B_phone" value="[% patron.B_phone | html %]" />
                [% IF ( mandatoryB_phone ) %]<span class="required">Required</span>[% END %]
            </li>
        [% END %]
        [% UNLESS noB_email %]
            <li>
        [% IF ( mandatoryB_email ) %]
          <label for="B_email" class="required">
        [% ELSE %]
          <label for="B_email">
        [% END %]
        Email: </label>
            <input type="text" id="B_email" name="B_email" size="45" value="[% patron.B_email | html %]" />
        [% IF ( mandatoryB_email ) %]<span class="required">Required</span>[% END %] </li>
        [% END %]
        [% UNLESS nocontactnote %]
            <li>
                [% IF ( mandatorycontactnote ) %]
                <label for="contactnote" class="required">
                [% ELSE %]
                <label for="contactnote">
                [% END %]
                Contact note: </label>
                <textarea id="contactnote" name="contactnote" cols="40" rows="2">[% patron.contactnote | html %]</textarea>
        [% IF ( mandatorycontactnote ) %]<span class="required">Required</span>[% END %]
            </li>
        [% END %]
            </ol>
        </fieldset>
